# xv6-public-modified

## Usage

```bash
make clean
make qemu SCHEDFLAG=<FLAG> CPUS=<NUMBER>
```

The appropriate schedflag and number of CPUs is chosen.

## Syscall Overview

* waitx syscall
The waitx syscall takes in two parameters and returns the run time and waittime of the process.

```c
status = waitx(&a, &b);
```

* pinfo syscall
The syscall takes in two parameters. One is a proc_struct variable and the other is the PID of the process whose information is to be found.
The proc_struct is populated from the ptable.

```c
getpinfo(&p, pid)
```

*ps syscall
The ps syscall gives a detailed list of all the processes present in the system at that particular instant. It loops through the ptable to obtain the details of the processes.

```c
  cprintf("name \t pid \t stat \t    priority \t   ctime \t  \n");
```

*set_priority syscall
The ser_priority syscall takes in two parameters (PID, PRIORITY) and sets the priority of the process with that PID to the one passed as a parameter.

```c
set_priority(atoi(argv[1]),atoi(argv[2])
```

## Scheduler Overview

### FCFS

As the name suggests, the process that arrives first is assigned CPU time first. Only once it is done is another process assigned that CPU.
This is a non preemptive policy. Hence if a process with a longer CPU burst time arrives first and one with a shorter CPU burst time arrives next, the second process will have to wait till the longer process is done (in case of 1 CPU). Processes are picked based on least creation time.

```c
      struct proc *min_process = p;

      if (p->state != RUNNABLE)
        continue;
      // cprintf("p->name %s p->pid %d  p->state = %d\n", p->name, p->pid, p->state);

      for (p2 = ptable.proc; p2 < &ptable.proc[NPROC]; p2++)
      {
        if (p2->state != RUNNABLE)
          continue;
        if (p2->pid <= 2)
          continue;
        if (p2->ctime < p->ctime)
          min_process = p2;
      }

      p = min_process;
```

### ROUND ROBIN - DEFAULT

This is the default scheduling algorithm. The processes are preemted from the CPU they were assigned to once their time slice expires. This ensures that all processes in the ready queue are given CPU attention.

```c
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
      p->num_run++;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
```

### PRIORITY BASED SCHEDULING

Each process is assigned a default priority of 60. If the processes are of equal priority then they execute round robin. The processes with higher priority are chosen and given CPU attention before the ones with lower priority. (A lower value of priority indicates a higher priority).
The set_priority syscall can be used to change the priority of the processes. Processes are picked based on highest priority.

```c
struct proc *highest_priority = 0;
      struct proc *p1 = 0;

      // cprintf("p->name %s p->pid %d  p->state = %d\n", p->name, p->pid, p->state);

      if (p->state != RUNNABLE)
        continue;
      highest_priority = p;
      for (p1 = ptable.proc; p1 < &ptable.proc[NPROC]; p1++)
      {
        if ((p1->state == RUNNABLE) && (highest_priority->priority > p1->priority))
          highest_priority = p1;
      }

      p = highest_priority;
```

### MULTI-LEVEL FEEDBACK QUEUE

* There are five priority queues, with the highest priority being number as 0 and bottom queue with the lowest priority as 4. The time slices of the 5 queues are {1,2,4,8,16}. If the number of ticks that a process receives in that queue exceeds the permissible number of ticks it is downgraded to a lower queue.
* A new process always starts in the Q0, after which it is moved down as time proceeds.
* If the process used the complete time slice assigned for its current priority queue, it is pre-empted and ​ inserted at the end of the next lower level queue.
* A round-robin scheduler should be used for processes at the lowest priority queue.
* To prevent starvation ageing is implemented wherein if a process has been waiting for CPU attention for more than its wait time, it is moved one queue up.
* Example for Queue 0

```c
if (c0 != -1) // ENTERING QUEUE 0
    {
      for (i = 0; i <= c0; i++)
      {
        if (q0[i]->state != RUNNABLE)
          continue;
        q0[i]->start=ticks;
        m_proc = q0[i];
        display_queues();
        c->proc = m_proc;
        switchuvm(m_proc);
        m_proc->state = RUNNING;
        m_proc->num_run++;
        swtch((&c->scheduler), m_proc->context);
        switchkvm();
        c->proc = 0;

        //check if time slice expired or waittime exceeded
        if ((m_proc->ticks[0] >= clockperiod[0]) && m_proc->pid > 3)
        {
          //copy proc to lower priority queue
          if (m_proc->killed == 0)
          {
            cprintf("\033[1;31m (%d,%s) switching to queue 1      since ticks of [0]= %d\n\033[0m", m_proc->pid,m_proc->name, m_proc->ticks[0]);
            c1++;
            m_proc->current_queue++;
            q1[c1] = m_proc;
          }
          //delete proc from q0
          for (j = i; j <= c0 - 1; j++)
            q0[j] = q0[j + 1];
          m_proc->ticks[0] = 0;
          c0--;
        }
      }
    }
```
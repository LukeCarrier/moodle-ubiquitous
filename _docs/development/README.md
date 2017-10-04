# Developing Ubiquitous

A rudimentary understanding of Salt concepts is essential: Ubiquitous is just an ordinary Salt state tree. The [Get Started tutorials](https://docs.saltstack.com/en/getstarted/) and ["Salt in ten minutes" walkthrough](https://docs.saltstack.com/en/latest/topics/tutorials/walkthrough.html) are great starting points.

## Ad hoc testing using Vagrant snapshots

Prepare a VM and snapshot it:

```
$ vagrant up app-debug-1
$ vagrant snapshot save app-debug-1 pre-state
```

Then relaunch it from the snapshot, over and over:

```
$ vagrant snapshot restore app-debug-1 pre-state
$ vagrant ssh --command 'sudo salt-call -l debug state.apply' app-debug-1
```

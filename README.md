ForkableClient
==============

Like modifying code on the fly? Like reworking internals of running
code to do interesting things? Like not losing a huge chunk of memory
because some jerk cookbook decided to load a 100M json file just for
the hell of it? Then this cookbook is for you!

What's it do?
-------------

This cookbook adds forking support to chef-client runs. It is based on the
work within [this ticket](http://tickets.opscode.com/browse/CHEF-3104). 
After this cookbook has loaded, client runs will fork themselves and then 
converge. What this provides is less worry about what cookbooks may 
be doing (and loading) that is going to bloat out the memory of the process. 
It's just that simple.

How do I use it?
----------------

Just add it to your node's run list (and probabably restart your daemon if it's
currently running)

  `knife node run_list add my.amazing.node recipe[forkable_client]`

Single runs
-----------

This cookbook does not work for single runs. It _requires_ an interval based
run (daemonized if you'd like), as the first run will fail by design. The reason
for the failure is that we need to adjust how the client performs the run, and
we don't want it to attempt to converge the node before we get the modifications
applied. So a first run will end with something like this:

```
ERROR: Running exception handlers
FATAL: Saving node information to /var/cache/chef/failed-run-data.json
ERROR: Exception handlers complete
ERROR: ForkedClientInsertion: Chef client is now forkable. This is a non-fatal error.
FATAL: Stacktrace dumped to /var/cache/chef/chef-stacktrace.out
ERROR: Sleeping for 5 seconds before trying again
```

But the next run will show the new functionality at work:

```
INFO: Forking chef instance to converge...
INFO: Fork successful. Waiting for new chef pid: 16231
INFO: Forked instance now converging
INFO: *** Chef 0.10.10 ***
...
INFO: Chef Run complete in 4.34858479 seconds
INFO: Running report handlers
INFO: Report handlers complete
INFO: Forked instance completed. Exiting.
INFO: Forked converge complete
```

References
----------

Repo: https://github.com/chrisroberts/cookbook-forkable_client

<small>
* http://tickets.opscode.com/browse/CHEF-3104
* https://github.com/opscode/chef/pull/291
</small>

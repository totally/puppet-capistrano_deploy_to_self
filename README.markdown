What: 
=====

Puppet module to get applications deployed to servers.

Includes upstart script that will deploy applications to localhost on startup.

Why:
----

When provisioning a server, this module allows puppet to bootstrap application code onto it.

Also, a server that is made from an older AMI will need the latest code deployed to it on startup. This is accomplished via the upstart script.

Usage:
-----
<pre>
    code_environment { 'my_awesome_application': app => 'my_awesome_application' }
</pre>

Dependencies:
-----

It's assumed that root user will have access to run:

<pre>
cap HOSTS=localhost deploy
</pre>

It's also assumed that capistrano config files live in:

<pre>
/root/capistrano/${application_name}
</pre>

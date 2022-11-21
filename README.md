# i-doit
i-doit kubernetes repo

1. use apache canonical image
2. apply i-doit website

I think you misunderstand what docker does (or I misunderstand your question). Docker is not a VM provider; it's a container management mechanism based on libcontainer. In your case, I would do something like

yum list installed
download a base docker image for centos version X (or you could create one from scratch)
pipe a subset of this output into a Dockerfile with yum install
create your image
if there are configs/non-RPM installs in your existing VM, either rebuild these in the container or worst case, share these
your MySQL is easier to manage; as long as the database folder/partition can be copied & shared with docker, you may be able to install mysql and use this. Have done this with postgres a number of times and hoping mysql is similarly clean.

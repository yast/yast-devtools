## Jenkins tools

Jenkins tools are intended to help with mass operations
on <http://ci.opensuse.org/>

They are not intended to be distributed in a RPM.
Usage requires reading the source code of each tool. Configuration is partly
done directly in the source.
If you can do your task quicker than reading the script
then it is not the right tool for you.

They can be used only if you have an account with proper rights.
In the same directory, copy the template `jenkins.yml.template` to a file
`jenkins.yml` and fill required credentials.

## Hints about jenkins

- general API hint: look at ci.opensuse.org/api . For api for given page append `/api/xml`.
  For config xml append to job view `/config.xml` like <https://ci.opensuse.org/view/Yast/job/yast-users-master/config.xml>.

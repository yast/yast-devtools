Jenkins tools are intended to help with mass operations
on <http://ci.opensuse.org/>

They are not intended to be distributed in a RPM.
Usage requires reading the source code of each tool. Configuration is partly
done directly in the source.
If you can do your task quicker than reading the script
then it is not the right tool for you.

They can be used only if you have an account with proper rights.
In the same directory, create a file `jenkins.yml`, a trivial map with:

    user: foo
    pwd: bar

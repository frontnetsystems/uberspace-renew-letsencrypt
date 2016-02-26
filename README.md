# uberspace-renew-letsencrypt

Forked from https://github.com/lebochequirit/uberspace-renew-letsencrypt, added some output and an installation script.

A script to implement painless Lets's Encrypt Certificate renewal for ubernauts. It checks whether a Let's encrypt SSL cert is still valid and otherwise renews it.

Put it somewhere on your uberspace, eg. /home/$USER/scripts, either by cloning the repo or download the ZIP.

Added installer script. Just call

```
[ubernaut@host scripts] sh uberspace-install-renew-letsencrypt.sh
```

And follow the instructions.

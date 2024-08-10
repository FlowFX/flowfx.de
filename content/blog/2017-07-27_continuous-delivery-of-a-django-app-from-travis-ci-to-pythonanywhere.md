---
title: "Continuous deployment of a Django app from Travis CI to PythonAnywhere"
slug: continuous-delivery-of-a-django-app-from-travis-ci-to-pythonanywhere
date: 2017-07-27
tags: ["pythonanywhere", "django", "python", "travis ci", "continuous deployment", "github"]
categories: ["tech"]
---


This post describes the configuration of a continuous deployment pipeline that deploys a Django project from [GitHub](https://github.com/FlowFX/unkenmathe.de/) via [Travis CI](https://travis-ci.org/) to [PythonAnywhere](https://www.pythonanywhere.com/user/flowfx/consoles/).

All code samples come from a pet project of mine: [Unkenmathe](https://www.unkenmathe.de) ([GitHub repository](https://github.com/flowfx/unkenmathe.de)).

Please note that this is no introduction to Travis CI, PythonAnywhere nor Git.

Here are the steps that I take.

## 1. Deploy Django project
PythonAnywhere's guide for [Deploying an existing Django project on PythonAnywhere](https://help.pythonanywhere.com/pages/DeployExistingDjangoProject) explains everything to manually set  up the web app.

For reference, the Unkenmathe code is checked out to

```bash
/var/www/sites/unkenmathe.de
```

and the virtual environment lives at

```bash
~/.virtualenvs/unkenmathe.de/
```

## 2. Prepare Git push deployment
PythonAnywhere has a comprehensive guide to set up [Git push deployments](https://blog.pythonanywhere.com/87/).

My bare repository is located at

```bash
~/bare-repos/unkenmathe.git
```


The `post-receive` hook looks like this:

```
# ~/bare-repos/unkenmathe.git/hooks/post-receive
#!/bin/bash

BASE_DIR=/var/www/sites/unkenmathe.de
PYTHON=$HOME/.virtualenvs/unkenmathe.de/bin/python
PIP=$HOME/.virtualenvs/unkenmathe.de/bin/pip
MANAGE=$BASE_DIR/manage.py

echo "=== configure Django ==="
export DJANGO_SETTINGS_MODULE=config.settings.production

echo "=== create base directory ==="
mkdir -p $BASE_DIR

echo "=== checkout new code ==="
GIT_WORK_TREE=$BASE_DIR git checkout -f

echo "=== install dependencies in virtual environment ==="
$PIP install -q -r $BASE_DIR/requirements/production.txt

echo "=== collect static files ==="
$PYTHON $MANAGE collectstatic --no-input

echo "=== update database ==="
$PYTHON $MANAGE migrate --no-input
```


## 3. Custom deployment with Travis CI
I set up the repository in Travis CI for automatic builds on pull requests and branch pushes. In order to deploy to PythonAnywhere, I use Travis's [Custom deployment](https://docs.travis-ci.com/user/deployment/custom/).

All Travis related files live in the `.travis` subdirectory of the Django project. This is of course completely arbitrary.

```bash
~ $ cd ~/code/unkenmathe/
unkenmathe $ mkdir .travis
unkenmathe $ cd .travis
```

### Create SSH keys
`git push` uses SSH, so I need a pair of SSH keys.

```bash
.travis $ ssh-keygen -t rsa -b 4096 -C 'hallo@example.com' -f deploy_key
```

Copy the public key to the PythonAnywhere account (see PythonAnywhere: [SSH access](https://help.pythonanywhere.com/pages/SSHAccess)).

```bash
.travis $ ssh-copy-id -i deploy_key flowfx@ssh.pythonanywhere.com
```

### Encrypt SSH key and add it to the repository
Travis offers a tool to encrypt files  that allows to add the SSH private key to the Git repository. See [Encrypting files](https://docs.travis-ci.com/user/encrypting-files/) for a complete how-to.

First, I encrypt the deploy key,

```bash
.travis $ travis login
.travis $ travis encrypt-file deploy_key --add
```

then add it to the Git repository.

```bash
.travis $ git add deploy_key.enc
```

Last, I make sure the decrypted key is never pushed to the public GitHub repository:

```bash
unkenmathe $ echo 'deploy_key' >> .gitignore
```


### Configure Travis CI
A simplified `.travis.yml` configuration file ([here the one used for Unkenmathe](https://github.com/FlowFX/unkenmathe.de/blob/master/.travis.yml)) looks like this. The `before_install` part is added automatically by the `travis encrypt-file deploy_key --add` command. The `ssh_known_hosts` line is also required for push deployment with Git/SSH.

Hopefully, the rest is documented sufficiently by the comments.

```yaml
# .travis.yml
language: python
cache: pip
python:
- 3.6
addons:
  # add PythonAnywhere server to known hosts
  ssh_known_hosts: ssh.pythonanywhere.com
before_install:
  # decrypt ssh private key
  - openssl aes-256-cbc -K $encrypted_xxxxxxxxxxxx_key -iv $encrypted_xxxxxxxxxxxx_iv -in .travis/deploy_key.enc -out deploy_key -d
install: pip install -r requirements/testing.txt
script:
  # run test suite
  - pytest --cov
after_success:
  # start ssh agent and add private key
  - eval "$(ssh-agent -s)"
  - chmod 600 deploy_key
  - ssh-add deploy_key
  # configure remote repository
  - git remote add pythonanywhere flowfx@ssh.pythonanywhere.com:/home/flowfx/bare-repos/unkenmathe.git
  # push master branch to production 
  - git push -f pythonanywhere master
  # reload PythonAnywhere web app via the API
  - python .travis/reload-webapp.py
after_deploy:
  # update coveralls.io
  - coveralls
notifications:
  # spare me from email notifications
  email: false
```


### Reload web app
The `after_success` step includes a call to `.travis/reload-webapp.py`, which is a Python script that reloads the web app via the [PythonAnywhere API](https://help.pythonanywhere.com/pages/API/). This is more or less copied directly from the documentation.

```
# .travis/reload-webapp.py
"""Script to reload the web app via the PythonAnywhere API.

"""
import os
import requests

my_domain = os.environ['PYTHONANYWHERE_DOMAIN']
username = os.environ['PYTHONANYWHERE_USERNAME']
token = os.environ['PYTHONANYWHERE_API_TOKEN']

response = requests.post(
    'https://www.pythonanywhere.com/api/v0/user/{username}/webapps/{domain}/reload/'.format(
        username=username, domain=my_domain
    ),
    headers={'Authorization': 'Token {token}'.format(token=token)}
)
if response.status_code == 200:
    print('All OK')
else:
    print('Got unexpected status code {}: {!r}'.format(response.status_code, response.content))

```

### Set environment variables

To make all this actually work, you need to set some environment variables in the Travis project settings. Namely `PYTHONANYWHERE_DOMAIN`, `PYTHONANYWHERE_USERNAME` and `PYTHONANYWHERE_API_TOKEN`.

Also, don't forget to set `DJANGO_SECRET_KEY`!

## Summary

These are the resources you need:

### PythonAnywhere

- [Deploying an existing Django project on PythonAnywhere](https://help.pythonanywhere.com/pages/DeployExistingDjangoProject)
- [Git push deployments](https://blog.pythonanywhere.com/87/)
- [SSH Access](https://help.pythonanywhere.com/pages/SSHAccess)
- [PythonAnywhere API](https://help.pythonanywhere.com/pages/API/)

### Travis CI

- [Custom deployment](https://docs.travis-ci.com/user/deployment/custom/)
- [Encrypting files](https://docs.travis-ci.com/user/encrypting-files/)

### Future

I need to look into Travis's [Script deployment](https://docs.travis-ci.com/user/deployment/script/) which looks like a much cleaner way to run the deployment commands.

### Comment!

If you find the one error that I missed, [please tell me about it](/contact)!

## Updates

- 5/9/2017: used Unkenmathe as example project, formatting.

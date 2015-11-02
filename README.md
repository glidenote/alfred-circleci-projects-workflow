# CircleCI Projects Workflow for Alfred 2


![]( ./images/alfred-circleci-projects-workflow00.png)
![]( ./images/alfred-circleci-projects-workflow01.png)

## Setup

1. Generate your CircleCI api token https://circleci.com/account/api
1. Set your token file in `config.rb`

![]( ./images/alfred-circleci-projects-workflow10.png)

![]( ./images/alfred-circleci-projects-workflow11.png)

## Commands

### ciu

Cache api response to `/var/tmp/circleci.json`

### ci

Open CircleCI Projects Page.
`ci` command uses cache file `/var/tmp/circleci.json`

### cis

Check master branch build status.
`cis` command uses CircleCI api server.



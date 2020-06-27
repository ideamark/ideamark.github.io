# Git


> [knowledgeQA start]

## how to modify git editor
git config --global core.editor vim

## how to do when git can not upload
1. Pull before push (Adviced)
git pull git@github.com:aaa/bbb.git master
git push -u git@github.com:aaa/bbb.git master
2. Force pushing (Danger)
git push -u git@github.com:aaa/bbb.git master -f

## how to recall git commit
git reset --soft HEAD^

## how to reset git
git log
git reset --hard <id>

## how to revert git
git revert HEAD

## how to redirect the domain to github pages
Add CNAME file in github main folder, the context is the domain.
Then, the domain, add the github A Record,
192.30.252.153
192.30.252.154

## how to diff by git
git diff (tree vs index)
git diff -cached (index vs commit)
git diff HEAD (tree vs commit)

## how to clean git log
git checkout --orphan xx
git add -A
git commit -am "clean"
git branch -D master
git branch -m master
git push -f

> [knowledgeQA end]

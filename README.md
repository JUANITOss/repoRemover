# repoRemover

A bash script that creates a python script inserted in your repo's folder, that can automatically delete any repo you want.

## What to modify...

* In line 21, change the "FOLDERS =" to your desired folder (this is where the script will be stored)
* In line 46, change the "~/Workspace" to your desired path (this is where the script will try to find directories)

## How to use...

* Run the script (no need to chmod anything)

```
./repoRemove.sh 
```

## In case it doesn't run...

* Extract the tar.gz file

```
tar -xzvf repo_remover_script.tar.gz
```

* Run the script (no need to chmod anything)

```
./repoRemove.sh 
```

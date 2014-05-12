# LogView

is a parallel monitoring logs gem who uses ssh connection to make tail on described files in multiple servers

## Installation
  
  Execute 

```sh
  $ gem install log_view
```

## Getting Started

1. Execute

```sh
$ log_view
```

The software will create a **.log_view.yml** file in your home directory

2. Configure the **.log_view.yml** file as the described example in the **.log_view.yml** file

3. Run:

```sh
$ log_view
```

This step will show your configured projects.

Use the described options in the output of third step to perform your logs

```sh
$ log_view <project-name> <options>
```

## Help

Execute command line without parameters

```sh
$ log_view
```

or

```sh
$ log_view -h
```

## Basic Commands

log_view gem offers four commands

### **--split-log**

The split-log option. This command will separate log by file and server

```sh
$ log_view <project_name> --split-log
```
    
### **--grep**

The grep option. This is the basic grep function. You should write like:

```sh
$ log_view <project_name> --grep <grep_string>
```
    
### **-s**

The choose server option. This command allow you to choose a single server to monitoring

```sh
$ log_view <project_name> -s <server name>
```

You can write any single parts of server's name. Like this exemple:

```yaml
project_name1:
user: a
password: b
servers: 
  - test-server1
  - test-server2
files:
  - test-file1
  - test-file2
```

```sh
$ log_view project_name1 -s server1
```

### **-f**

The choose file option. This command allow you to choose a single file to monitoring

```sh
$ log_view <project_name> -f <file name>
```

You can write any single parts of file's name. Like this exemple:

```yaml
project_name1:
user: a
password: b
servers: 
  - test-server1
  - test-server2
files:
  - test-file1
  - test-file2
```

```sh
$ log_view project_name1 -f file1
```

# Functions and String Operations

Terraform provides dozens of built-in functions. You cannot write your own custom functions in HCL; you must use what is provided.

You can test these functions interactively using the `terraform console` command.

## String Operations

String manipulation is heavily used for generating ARNs, formatting names, and parsing paths.

- **`join(separator, list)`**: Produces a string by concatenating a list of strings with a separator.
  `join("-", ["foo", "bar", "baz"])` → `"foo-bar-baz"`
- **`split(separator, string)`**: Splits a string into a list.
  `split(",", "foo,bar,baz")` → `["foo", "bar", "baz"]`
- **`replace(string, search, replace)`**: Replaces substrings.
  `replace("1.2.3.4", ".", "-")` → `"1-2-3-4"`
- **`lower(string)` / `upper(string)`**: Case conversion.
- **`substr(string, offset, length)`**: Extracts a substring.
  `substr("hello world", 0, 5)` → `"hello"`
- **`trimprefix` / `trimsuffix` / `trimspace`**: Removes specific characters.

## Filesystem Operations

Terraform relies heavily on files for user-data scripts, SSH keys, or policies.

### The `file()` Function

Reads the contents of a file as a string.
```hcl
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("${path.module}/id_rsa.pub")
}
```

### The `templatefile()` Function

Reads a file and renders it as a template, replacing variables with provided values. This is much cleaner than using string interpolation on large files.

`scripts/user_data.sh`:
```bash
#!/bin/bash
echo "Hello, my database is at ${db_host}:${db_port}"
```

`main.tf`:
```hcl
resource "aws_instance" "web" {
  ami       = "ami-12345"
  user_data = templatefile("${path.module}/scripts/user_data.sh", {
    db_host = aws_db_instance.main.endpoint
    db_port = 5432
  })
}
```

### Path Functions
- **`basename(path)`**: Returns the last element of a path (`basename("/foo/bar.txt")` → `"bar.txt"`).
- **`dirname(path)`**: Returns all but the last element (`dirname("/foo/bar.txt")` → `"/foo"`).
- **`abspath(path)`**: Returns an absolute path.
- **`fileexists(path)`**: Returns boolean true if the file exists.

## Collection Operations

Used for manipulating lists and maps.

- **`length(list/map/string)`**: Returns the number of items or characters.
- **`concat(list1, list2)`**: Combines two or more lists.
- **`merge(map1, map2)`**: Combines two or more maps. If keys overlap, the later map's value wins.
- **`keys(map)` / `values(map)`**: Extracts keys or values from a map as a list.
- **`contains(list, value)`**: Returns true if the list contains the value.
- **`flatten(list_of_lists)`**: Flattens nested lists into a single flat list. Highly useful for complex nested data structures.

## IP Network Functions

- **`cidrsubnet(prefix, newbits, netnum)`**: Calculates a subnet address within a given IP network address prefix.
  `cidrsubnet("10.0.0.0/16", 8, 2)` → `"10.0.2.0/24"`
- **`cidrhost(prefix, hostnum)`**: Calculates a full host IP within a CIDR.
  `cidrhost("10.0.0.0/16", 4)` → `"10.0.0.4"`

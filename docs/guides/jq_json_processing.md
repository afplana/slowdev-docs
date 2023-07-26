# Json Processing with `jq`

`jq` is a lightweight, command-line JSON processor. It's designed to work with JSON data in a shell scripting environment.

## Basic Usage

To start using `jq`, you can pipe JSON data to it through stdin. The `.` here is a filter that matches the entire input.

```sh
echo '{"name":"John", "age":30}' | jq .
```

## Accessing Values

You can access values within the JSON data using `.` notation. The `.name` filter selects the `name` field of the input object.

```sh
echo '{"name":"John", "age":30}' | jq .name
```

## Filters

`jq` is really powerful when it comes to filtering JSON data. The `.[]` filter enumerates all items in the array, and `select(.age > 28)` further filters those items by their `age` field.

```sh
echo '[{"name":"John", "age":30}, {"name":"Jane", "age":25}]' | jq '.[] | select(.age > 28)'
```

## Transformations

`jq` can also modify and transform JSON data. This command transforms a JSON object into another object with different keys but the same values.

```sh
echo '{"name":"John", "age":30}' | jq '{fullName: .name, yearsOld: .age}'
```

## Extract Nested Fields

This command demonstrates how to extract nested fields from a JSON object.

```sh
echo '{"name": "Allse", "addresses": [{"street":"gerade"}]}' | jq '.addresses[0].street'
```

## Read from File

Use `-r`` to get raw output, which will remove quotation marks from the output.

```sh
jq -r '.content' ~/stash/notes/scripts/sql/something.json
```

## Advanced Usage

You can use more complex `jq` scripts for processing large and complex JSON data. Example: To delete non-running pods with Kubernetes.

```sh
kubectl get pods --all-namespaces -o json |
jq -r '.items[] | select(.status.phase != "Running" or ([ .status.conditions[] | select(.type == "Ready" and .status == "False") ] | length ) == 1 ) | .metadata.namespace + "/" + .metadata.name' |
xargs -I {} kubectl delete pod {} --grace-period=0 --force
```

For more details, you can always refer to the `jq` [manual](https://jqlang.github.io/jq/manual/).

## Summary

`jq` is a powerful tool for JSON data processing in the shell. It reads JSON data from `stdin`, processes it, and outputs to `stdout`. You can also access and filter fields in JSON objects and arrays using dot notation and the `select()` function. It supports various transformations of JSON data, allowing you to reshape and manipulate data as needed. It provides options to handle nested JSON data as well. Using `-r`, you can get raw output, which can be useful when you want the result to be free from quotation marks. You can chain commands with other shell commands for advanced operations, `jq` supports more advanced operations and functions as well so be sure to check out the official `jq` [manual](https://jqlang.github.io/jq/manual/) for more detailed information. In a nutshell, `jq` provides you with a way to slice, filter, map, and transform structured data. It's like a Swiss army knife for JSON data and a **must-have** tool for any shell scripting toolkit!

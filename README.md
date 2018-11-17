# Secret Santa

Use this utility to create a set of matches for a secret santa gift swap.

## Getting Started

Download the project and get ready to create some fun!

Set up the people.json file to create your participants with relationships to avoid boring matches. 
Use the sample_people.json file as an example, and create as many files as you need to manage your groups.

Copy the sample_config.rb file to config.rb and set the config parameters for email information.

Run the secret santa script to match folks together and send them emails to let them know who gets whom.

### Prerequisities

You'll need to have ruby installed and a few gems.

configatron
json
OptionParser

## Running the tool

### Setting up families

Set up the people.json file as per this example:

```
{"family1": [
    {"name":"Mickey", "email":"mmouse@disney.com", "spouse":"Minnie"},
    {"name":"Minnie", "email":"mmouse2@disney.com", "spouse":"Mickey"},
    {"name":"Donald", "email":"dduck@disney.com", "spouse":"Daisy"},
    {"name":"Daisy", "email":"daisy@aol.com", "spouse":"Donald"},
  ],
  "family2": [
    {"name":"Harry", "email":"hp@jk.com", "spouse":"Ginny"},
    {"name":"Ginny", "email":"gw@jk.com", "spouse":"Harry"},
    {"name":"Hermionie", "email":"hg@jk.com", "spouse":"Ron"},
    {"name":"Ron", "email":"rw@jk.com", "spouse":"Hermionie"},
    {"name":"Draco", "email":"dm@jk.com"},
    {"name":"Albus", "email":"ad@jk.com"}
  ]
}
```

You can have multiple families and each person is identified by their name, email and spouse (optionally). The tool
will randomize the pairings and validate that no one has received a match with their spouse. If the validations pass, 
a valid set is achieved and emails can be sent out.

### Running the tool

```
Usage: secretsanta.rb [options]
    -i, --input-file filename        Input file name
    -f, --family-name familyname     Input family name to use
    -s, --send-emails                Turn on email sending
    -v, --verbose                    Turn on verbose messaging
```

## Authors

* **David Faux** - *Initial work* - [dfaux](https://github.com/dfaux/)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


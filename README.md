
## Requirements

To use this script, you must get an API key from [picnic.sh](http://picnic.sh)

## Installation

```
# download the script
curl -O https://raw.githubusercontent.com/ketchupinc/picnic-sh/master/picnic.sh

# make the script executable
chmod +x picnic.sh

# add your api key by opening the file and adding it to the top line
nano picnic.sh

```


## Examples

```
# list the websites you've purchased
./picnic.sh --list

# get the price of a new domain
./picnic.sh --price mynewdomain.com

# buy the domain and set the HTML
./picnic.sh --create mynewdomain.com "<html><body>coming soon.</body></html>"

# update the content of your website
./picnic.sh --update mynewdomain.com "<html><body>coming soon.</body></html>"
```

## Questions?

Contact us at help [ a t ] picnic.sh

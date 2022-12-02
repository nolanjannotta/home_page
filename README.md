concept:

a simple smart contract that manages on chain html pages. an address can create a "homepage" which technically is any html page. this can be a personal info page, resume, portfolio page, etc. addresses can also create children pages which are also html. these can be anything. some ideas are photos, blog, list and description of projects, etc. another idea is to deploy other contracts that have presets for certain pages, and functions that allow you to cheaply append data to the page without completely redeploying the entire page. these contracts will be connected somehow to the base "homepage" contract and will manage child pages. On its own this isnt very cool. this is meant to work closely with a simple frontend. the front end will have a router that lets you easily look up an address or ens names page. for example: www.homepage.com/0xbeef123 will display 0xbeef123's homepage. you can access children pages like this: www.homepage.com/0xbeef123/child. or, for example something like this: www.homepage.com/0xbeef123/photos or www.homepage.com/0xbeef123/blog etc.


inspired by frolic's file store contracts and uses his content store contracts.
to be linked *
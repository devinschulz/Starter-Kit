Starter-Kit
==========
A starter kit for projects

### How to get this project working:

1. Install Node. You can either install Node from its [source](http://nodejs.org/) or if you are using homebrew, run <code>brew install node</code>.

2. Download all the Node dependencies by running <code>npm install</code>.

3. Sass is a super awesome preprocessor, so you will be required to have Sass on your machine in order for things to work. If you do not have Ruby installed [follow this link](http://installrails.com/), otherwise run <code>bundle install</code> to install the projects dependencies. 

4. LiveReload is used to refresh the browser, please visit [how do I install and use the browser extensions](http://feedback.livereload.com/knowledgebase/articles/86242-how-do-i-install-and-use-the-browser-extensions-) for help installing an extension for your browser.

Grunt
==========
## Development
During development Grunt will watch your files by running <code>grunt watch</code>. 

## Deployment
For deployment run <code>grunt production</code>. Grunt will magically package, concatenate, combine and do some super awesome things for you; then store the package in a <code>dist</code> directory. From there you can upload  the <code>dist</code> contents to your webserver and happy time for all!


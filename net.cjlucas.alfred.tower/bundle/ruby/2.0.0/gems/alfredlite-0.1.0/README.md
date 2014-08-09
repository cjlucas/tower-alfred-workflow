[![Build Status](https://travis-ci.org/cjlucas/ruby-alfredlite.png?branch=master)](https://travis-ci.org/cjlucas/ruby-alfredlite)
[![Build Status](https://travis-ci.org/cjlucas/ruby-alfredlite.png?branch=develop)](https://travis-ci.org/cjlucas/ruby-alfredlite)
[![Gem Version](https://badge.fury.io/rb/alfredlite.png)](http://badge.fury.io/rb/alfredlite)

AlfredLite is a lightweight modular framework for creating 
[Alfred](http://www.alfredapp.com/) workflows.

## Features ##
 - Modular design
   - Only load the modules your workflow uses
   - Faster load times (execution speed is an underappreciated feature of any workflow)
   - Less bundeled dependencies
 - Subclassable workflows
   - `Alfred::Workflow` is designed to be subclassed, the possibilities are endless!

## Synopsis ##
Here's a trivial example of a workflow that utilizes Alfred's feedback system:
```ruby
require 'alfredlite' # this loads the workflow module
require 'alfredlite/feedback' # all submodules have to be loaded explicitly

class ExampleWorkflow < Alfred::Workflow
  BUNDLE_ID = 'net.cjlucas.alfred.example'

  def intitialize
    super(BUNDLE_ID)
  end

  def query(input)
    # parse the user's input
    data_array = get_imaginary_data(input)

    # add new feedback items to array
    data_array.each do |data|
      # Alfred::Workflow#feedback_items and Alfred::Feedback::Item
      # become available when the feedback module is loaded
      feedback_items << Alfred::Feedback::Item.new.tap do |item|
        item.title = data.info
        item.subtitle = data.more_info
        item.icon = '/path/to/icon.png'
      end
    end

    # send our feedback_items to Alfred to be processed and displayed
    puts feedback_items.to_xml
  end
end
```

Then we add a simple script for our Alfred workflow action
```ruby
require 'example_workflow'

ExampleWorkflow.new.query("{query}")
```


## Requirements ##
AlfredLite is tested against the following verions of Ruby:
  - 1.8.7 (preinstalled on OS X Mountain Lion)
  - 1.9.3
  - 2.0.0 (preinstalled on OS X Mavericks)

### Module-level dependencies ###
- Workflow module
  - None
- Feedback module
  - [REXML](http://www.germane-software.com/software/rexml/) (included with all versions of Ruby)

## Contributing ##
- Bug Fixes
  - Reporting bugs is encouraged and greatly appreciated, send them [here](https://github.com/cjlucas/ruby-alfredlite/issues).
  - If you're contributing a bug fix, please make sure you're committing your fixes on the `develop` branch 
    (bonus points for creating a dedicated bug fix branch).
- Feature Requests
  - Have an idea that will help make writing your workflows easier? Then submit it [here](https://github.com/cjlucas/ruby-alfredlite/issues).

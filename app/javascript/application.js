// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails'
import 'controllers'
import 'trix'
import '@rails/actiontext'
import drop_down from "./drop_down";

drop_down()


// gather allelements mentioning a certain id
// For each add an event listener which will take out the file name of the image and then add a class to hide
// then insert the image to the chilldren ement with the certain id
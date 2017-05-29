# INSTALL wicked_pdf

Add this to your Gemfile and run bundle install:
## gem 'wicked_pdf'

Then create the initializer with
## rails generate wicked_pdf

You may also need to add

Mime::Type.register "application/pdf", :pdf
to config/initializers/mime_types.rb in older versions of Rails.

Because wicked_pdf is a wrapper for wkhtmltopdf, you'll need to install that, too.

The simplest way to install all of the binaries (Linux, OSX, Windows) is through the gem wkhtmltopdf-binary. To install that, add a second gem

## gem 'wkhtmltopdf-binary'
To your Gemfile and run bundle install.

This wrapper may trail in versions, at the moment it wraps the 0.9 version of wkhtmltopdf while there is 0.12 version available. Some of the advanced options listed below are not available with 0.9.

If your wkhtmltopdf executable is not on your webserver's path, you can configure it in an initializer:

* WickedPdf.config = {
*   exe_path: '/usr/local/bin/wkhtmltopdf'
* }

# CSS
aplication.html
http://stackoverflow.com/questions/27367752/how-to-load-css-in-pdf-using-wicked-pdf


<%= wicked_pdf_stylesheet_link_tag "print" -%>
<%= wicked_pdf_stylesheet_link_tag "application", "data-turbolinks-track" => true %>
<%= wicked_pdf_javascript_include_tag "application", "data-turbolinks-track" => true %>
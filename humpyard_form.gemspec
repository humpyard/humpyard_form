# Generated by rake
# DO NOT EDIT THIS FILE DIRECTLY
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{humpyard_form}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sven G. Broenstrup", "Andreas Pieper"]
  s.date = %q{2010-09-21}
  s.description = %q{HumpyardForm is an form builder for Rails 3 applications. It is developed as part of the humpyard cms}
  s.email = %q{info@humpyard.org}
  s.files = ["lib/humpyard_form", "lib/humpyard_form/action_controller", "lib/humpyard_form/action_controller/base.rb", "lib/humpyard_form/action_view", "lib/humpyard_form/action_view/form_helper.rb", "lib/humpyard_form/compass.rb", "lib/humpyard_form/config.rb", "lib/humpyard_form/engine.rb", "lib/humpyard_form/form_builder.rb", "lib/humpyard_form.rb", "app/views/humpyard_form/_boolean_input.html.haml", "app/views/humpyard_form/_color_input.html.haml", "app/views/humpyard_form/_date_input.html.haml", "app/views/humpyard_form/_datetime_input.html.haml", "app/views/humpyard_form/_email_input.html.haml", "app/views/humpyard_form/_file_input.html.haml", "app/views/humpyard_form/_form.html.haml", "app/views/humpyard_form/_form_element.html.haml", "app/views/humpyard_form/_image_file_input.html.haml", "app/views/humpyard_form/_month_input.html.haml", "app/views/humpyard_form/_numeric_input.html.haml", "app/views/humpyard_form/_password_input.html.haml", "app/views/humpyard_form/_range_input.html.haml", "app/views/humpyard_form/_search_input.html.haml", "app/views/humpyard_form/_select_input.html.haml", "app/views/humpyard_form/_string_input.html.haml", "app/views/humpyard_form/_submit.html.haml", "app/views/humpyard_form/_tel_input.html.haml", "app/views/humpyard_form/_text_input.html.haml", "app/views/humpyard_form/_time_input.html.haml", "app/views/humpyard_form/_url_input.html.haml", "app/views/humpyard_form/_week_input.html.haml", "config/locales/de.yml", "config/locales/en.yml", "compass/stylesheets", "compass/stylesheets/_humpyard_form.sass", "compass/stylesheets/humpyard_form", "compass/stylesheets/humpyard_form/_base.sass", "VERSION", "README.rdoc", "LICENCE", "Gemfile"]
  s.homepage = %q{http://humpyard.org/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{HumpyardForm is a Rails form builder}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 0"])
      s.add_runtime_dependency(%q<rails>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<haml>, [">= 3.0.0"])
      s.add_runtime_dependency(%q<compass>, [">= 0.10.0"])
      s.add_runtime_dependency(%q<globalize3>, [">= 0.0.7"])
    else
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 3.0.0"])
      s.add_dependency(%q<haml>, [">= 3.0.0"])
      s.add_dependency(%q<compass>, [">= 0.10.0"])
      s.add_dependency(%q<globalize3>, [">= 0.0.7"])
    end
  else
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 3.0.0"])
    s.add_dependency(%q<haml>, [">= 3.0.0"])
    s.add_dependency(%q<compass>, [">= 0.10.0"])
    s.add_dependency(%q<globalize3>, [">= 0.0.7"])
  end
end

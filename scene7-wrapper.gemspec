# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scene7-wrapper}
  s.version = "0.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Brian Rose", "Jim Whiteman"]
  s.date = %q{2011-04-13}
  s.description = %q{A Scene7 wrapper for Rails 3.x apps.}
  s.email = %q{brian.rose@factorylabs.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".rvmrc",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/scene7-wrapper.rb",
    "lib/scene7/asset.rb",
    "lib/scene7/client.rb",
    "lib/scene7/company.rb",
    "lib/scene7/config.rb",
    "lib/scene7/crop.rb",
    "lib/scene7/folder.rb",
    "scene7-wrapper.gemspec",
    "spec/file_fixtures/fpo.jpg",
    "spec/fixtures/create_folder/folder.xml",
    "spec/fixtures/delete_asset/success.xml",
    "spec/fixtures/delete_folder/empty_response.xml",
    "spec/fixtures/get_active_jobs/no_publish_job.xml",
    "spec/fixtures/get_active_jobs/one_publish_job.xml",
    "spec/fixtures/get_assets/all_assets.xml",
    "spec/fixtures/get_assets_by_name/hat_asset.xml",
    "spec/fixtures/get_assets_by_name/jacket_asset.xml",
    "spec/fixtures/get_assets_by_name/zero_found.xml",
    "spec/fixtures/get_company_info/company.xml",
    "spec/fixtures/get_company_info/test_request.xml",
    "spec/fixtures/get_folders/folders.xml",
    "spec/fixtures/rename_asset/failure.xml",
    "spec/fixtures/rename_asset/success.xml",
    "spec/fixtures/stop_job/response.xml",
    "spec/fixtures/submit_job/image_serving_publish_job_response.xml",
    "spec/fixtures/submit_job/upload_urls_job_response.xml",
    "spec/scene7/asset_spec.rb",
    "spec/scene7/client_spec.rb",
    "spec/scene7/company_spec.rb",
    "spec/scene7/config_spec.rb",
    "spec/scene7/crop_spec.rb",
    "spec/scene7/folder_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/factorylabs/scene7-wrapper}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{A Scene7 wrapper for Rails 3.x apps.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<savon>, [">= 0"])
      s.add_runtime_dependency(%q<httpclient>, [">= 0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<savon_spec>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug>, [">= 0"])
      s.add_development_dependency(%q<timecop>, [">= 0"])
    else
      s.add_dependency(%q<savon>, [">= 0"])
      s.add_dependency(%q<httpclient>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<savon_spec>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
      s.add_dependency(%q<timecop>, [">= 0"])
    end
  else
    s.add_dependency(%q<savon>, [">= 0"])
    s.add_dependency(%q<httpclient>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<savon_spec>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
    s.add_dependency(%q<timecop>, [">= 0"])
  end
end


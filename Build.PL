
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Find" => 0,
    "Module::Build" => "0.3601",
    "Test::More" => "0.88"
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "update i18n messages.pot file with new strings",
  "dist_author" => [
    "Jerome Quelin <jquelin\@gmail.com>"
  ],
  "dist_name" => "Dist-Zilla-App-Command-pot",
  "dist_version" => "1.112680",
  "license" => "perl",
  "module_name" => "Dist::Zilla::App::Command::pot",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Dist::Zilla::App" => 0,
    "File::Temp" => 0,
    "IO::Prompt" => 0,
    "Moose::Autobox" => 0,
    "Path::Class" => 0,
    "perl" => "5.012",
    "strict" => 0,
    "warnings" => 0
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;

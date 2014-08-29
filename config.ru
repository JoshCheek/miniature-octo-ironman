require 'pp'
$LOAD_PATH << File.expand_path('lib', __dir__)
pp $LOAD_PATH
require "app"

run MiniatureOctoIronman

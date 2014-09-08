require 'open3'
require 'tmpdir'

class FsHelpers
  attr_accessor :datadir

  def initialize(datadir)
    self.datadir = datadir
    raise "#{datadir.inspect} is not absolute" unless datadir.start_with? '/'
  end

  def reset_datadir
    delete datadir
    mkdir  datadir
  end

  def make_upstream_repo(n=nil)
    if n
      make_repo_at upstream_repo_path("repo#{n}")
    else
      make_repo_at upstream_repo_path
    end
  end

  def make_repo_at(path)
    mkdir path
    cd path do
      write 'somefile', 'some content'
      sh 'git init'
      sh 'git add .'
      sh 'git commit -m "This is a test repo"'
    end
    path
  end

  def upstream_repo_path(repo_name='default_repo')
    File.join upstream_path, repo_name
  end

  def upstream_path
    File.join datadir, 'upstream'
  end

  def mkdir(dir)
    return if Dir.exist? dir
    mkdir File.dirname(dir)
    Dir.mkdir dir
  end

  def cd(path, &block)
    raise 'Only use the block form of cd' unless block
    Dir.chdir(path, &block)
  end

  def write(filename, content)
    File.write filename, content
  end

  def delete(file_or_dir)
    if Dir.exist?(file_or_dir)
      (Dir.entries(file_or_dir) - ['.', '..'])
        .each { |relative_entry| delete File.join(file_or_dir, relative_entry) }
      Dir.delete file_or_dir
    elsif File.exist?(file_or_dir)
      File.delete file_or_dir
    end
  end

  def sh(command)
    output, error, status = Open3.capture3(command)
    return output if status.success?
    puts "SH FAILED:"
    puts "  ERR:    #{error.inspect}"
    puts "  OUT:    #{output.inspect}"
    puts "  STATUS: #{status.exitstatus}"
    require "pry"
    binding.pry
  end

  def current_sha(path)
    sh "git log --pretty=format:%H -1"
  end
end

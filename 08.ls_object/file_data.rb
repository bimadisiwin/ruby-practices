# frozen_string_literal: true

require 'etc'

module Ls
  class FileData
    OCT_TO_RWX = {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }.freeze

    def initialize(file)
      @file = file
      @lstat = File.lstat(@file)
    end

    def ftype
      type = @lstat.ftype
      lists = {
        'directory' => 'd',
        'link' => 'l',
        'file' => '-'
      }
      lists[type]
    end

    def permission
      permission = @lstat.mode.to_s(8)[-3..]
      change_permission_style(permission).join
    end

    def nlink
      @lstat.nlink
    end

    def user_name
      Etc.getpwuid(@lstat.uid).name
    end

    def group_name
      Etc.getgrgid(@lstat.gid).name
    end

    def size
      @lstat.size
    end

    def mtime
      @lstat.mtime.strftime('%a %e %H:%M')
    end

    def name
      @file
    end

    private

    def change_permission_style(permission)
      permission.each_char.map do |digit|
        OCT_TO_RWX.fetch(digit)
      end
    end
  end
end

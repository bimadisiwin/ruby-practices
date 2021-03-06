# frozen_string_literal: true

# !/usr/bin/env ruby

require './formatter'

module Ls
  class FileList
    def initialize(opt)
      @opts = opt
    end

    def output_files(opt)
      formatter = Ls::Formatter.new
      if opt['l']
        formatter.output_detail(target_files)
      else
        formatter.output_simple(target_files)
      end
    end

    def target_files
      target_files = if @opts['a']
                       Dir.glob('*', File::FNM_DOTMATCH).sort
                     else
                       Dir.glob('*').sort
                     end

      target_files = target_files.reverse if @opts['r']
      target_files
    end
  end
end

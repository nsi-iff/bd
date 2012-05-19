module Zip
  class ZipEntry
    def initialize(zipfile = "", name = "", comment = "", extra = "",
                   compressed_size = 0, crc = 0, 
                   compression_method = ZipEntry::DEFLATED, size = 0,
                   time  = DOSTime.new)
      super()
      if name.start_with?("/")
        raise ZipEntryNameError, "Illegal ZipEntry name '#{name}', name must not start with /"
      end
      @localHeaderOffset = 0
      @local_header_size = 0
      @internalFileAttributes = 1
      @externalFileAttributes = 0
      @header_signature = CENTRAL_DIRECTORY_ENTRY_SIGNATURE
      @versionNeededToExtract = VERSION_NEEDED_TO_EXTRACT
      @version = 52 # this library's version
      @ftype = nil # unspecified or unknown
      @filepath = nil
      if Zip::RUNNING_ON_WINDOWS
        @fstype = FSTYPE_FAT
      else
        @fstype = FSTYPE_UNIX
      end
      @zipfile = zipfile
      @comment = comment
      @compressed_size = compressed_size
      @crc = crc
      @extra = extra
      @compression_method = compression_method
      @name = name
      @size = size
      @time = time
      @gp_flags = 0

      @follow_symlinks = false

      @restore_times = true
      @restore_permissions = false
      @restore_ownership = false

# BUG: need an extra field to support uid/gid's
      @unix_uid = nil
      @unix_gid = nil
      @unix_perms = nil
#      @posix_acl = nil
#      @ntfs_acl = nil

      if name_is_directory?
        @ftype = :directory
      else
        @ftype = :file
      end

      unless ZipExtraField === @extra
        @extra = ZipExtraField.new(@extra.to_s)
      end

      @dirty = false
    end
  end
end

# Copyright (C) 2002, 2003 Thomas Sondergaard
# rubyzip is free software; you can redistribute it and/or
# modify it under the terms of the ruby license.

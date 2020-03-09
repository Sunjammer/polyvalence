package polyvalence.data.wad;

import sys.io.FileInput;

using polyvalence.io.MacCompat;
using polyvalence.io.BinDump;
using StringTools;

enum abstract WadfileVersion(Int) from Int to Int {
	var PreEntryPoint;
	var HasDirectoryEntry;
	var SupportsOverlays;
	var HasInfinityStuff;
}

enum abstract WadfileDataVersion(Int) from Int to Int {
	var Marathon;
	var MarathonTwo;
}

class WadFile {
	static final MAXIMUM_WADFILE_NAME_LENGTH = 64;

	public var version:WadfileVersion;
	public var data_version:WadfileDataVersion;

	var checksum:Int;
	var directory_offset:Int;

	public var wad_count:Int;

	var application_specific_directory_data_size:Int;
	var entry_header_size:Int;
	var directory_entry_base_size:Int;
	var parent_checksum:Int;

	public var file_name:String;

	public var directory:Map<Int, DirectoryEntry> = new Map();

	public function new(file:FileInput, fork_start:Int) {
		readHeader(file);
		// No M1 compat for now since it makes reading data a chore
		readDirectory(file, fork_start);
		trace("Done");
		dumpDirectory();
	}

	function dumpDirectory() {
		trace("Dumping directory");
		for (d in directory) {
			d.dumpDirectoryEntry(file_name);
		}
	}

	inline function checkVersion(vs:Int) {
		return vs == data_version;
	}

	function readHeader(file:FileInput) {
		// short version;									/* Used internally */
		version = file.readInt16();
		trace("Version: " + version);
		// short data_version;								/* Used by the data.. */
		data_version = file.readInt16();
		trace("Data version: " + data_version);
		// char file_name[MAXIMUM_WADFILE_NAME_LENGTH];
		file_name = file.readMacString(MAXIMUM_WADFILE_NAME_LENGTH).trim();
		trace("File name: " + file_name);
		// unsigned long checksum;
		checksum = file.readUint32B();
		// long directory_offset;
		directory_offset = file.readInt32();
		trace("Directory offset: " + directory_offset);
		// short wad_count;
		wad_count = file.readInt16();
		// short application_specific_directory_data_size;
		application_specific_directory_data_size = file.readInt16();
		// short entry_header_size;
		entry_header_size = file.readInt16();
		// short directory_entry_base_size;
		directory_entry_base_size = file.readInt16();
		// unsigned long parent_checksum;	/* If non-zero, this is the checksum of our parent, and we are simply modifications! */
		parent_checksum = file.readUint32B();
		// short unused[20];
		file.read(2 * 20);
	}

	function readDirectory(file:FileInput, fork_start:Int) {
		var start = directory_offset + fork_start;
		file.seek(start, SeekBegin);
		trace("Reading directory... " + (start));

		switch (data_version) {
			case Marathon:
				trace("Is M1");
			case MarathonTwo:
				trace("Is M2");
			default:
				throw "Unknown data_version";
		}

		for (i in 0...wad_count) {
			var entry = new DirectoryEntry();
			entry.loadEntry(file);
			directory[entry.index] = entry;
			loadApplicationSpecificDirectoryData(file, entry.index);
		}
		readChunks(file, fork_start);
	}

	function loadApplicationSpecificDirectoryData(file:FileInput, index:Int) {
		file.read(application_specific_directory_data_size);
	}

	function readChunks(file:FileInput, fork_start:Int) {
		trace("Reading chunks... " + (directory_offset + fork_start));
		for (entry in directory) {
			var start = entry.offset + fork_start;
			file.seek(start, SeekBegin);
			trace("Entry start: " + start);
			entry.loadChunks(file);
		}
	}
}

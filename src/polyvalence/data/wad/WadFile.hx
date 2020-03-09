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
	
		trace("Read header, current pos is "+file.tell());

		readDirectory(file, fork_start);
		readChunks(file, fork_start);

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
		trace("Wad count: " + wad_count);
		// short application_specific_directory_data_size;
		application_specific_directory_data_size = file.readInt16();
		trace("application_specific_directory_data_size: " + application_specific_directory_data_size);
		// short entry_header_size;
		entry_header_size = file.readInt16();
		trace("entry_header_size: " + entry_header_size);
		// short directory_entry_base_size;
		directory_entry_base_size = file.readInt16();
		trace("directory_entry_base_size: " + directory_entry_base_size);
		// unsigned long parent_checksum;	/* If non-zero, this is the checksum of our parent, and we are simply modifications! */
		parent_checksum = file.readUint32B();
		trace("parent_checksum: " + parent_checksum);
		// short unused[20];
		file.read(2 * 20);
	}

	function readDirectory(file:FileInput, fork_start:Int) {
		var start = directory_offset + fork_start;
		file.seek(start, SeekBegin);
		trace("Reading directory... " + start);

		switch (data_version) {
			case Marathon:
				trace("Is M1");
			case MarathonTwo:
				trace("Is M2");
			default:
				throw "Unknown data_version";
		}
		for (i in 0...wad_count) {
			var entry = DirectoryEntry.load(file, data_version, application_specific_directory_data_size, i);
			directory[entry.index] = entry;
		}
	}

	function readChunks(file:FileInput, fork_start:Int) {
		for (entry in directory) {
			var start = fork_start + entry.offset;
			file.seek(start, SeekBegin);
			entry.loadChunks(file);
		}
	}
}

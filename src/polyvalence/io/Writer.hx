package polyvalence.io;

class Writer{
    
}



	/*public void Save(string filename) {
	    using (FileStream fs = File.Open(filename, FileMode.OpenOrCreate, FileAccess.Write)) {
		CrcStream crcStream = new CrcStream(fs);
		BinaryWriterBE writer = new BinaryWriterBE(crcStream);

		// set up the header
		if (Directory.Count == 1) {
		    version = (short) WadfileVersion.SupportsOverlays;
		} else {
		    version = (short) WadfileVersion.HasInfinityStuff;
		}
	    
		DataVersion = (short) WadfileDataVersion.MarathonTwo;
		checksum = 0;
		directoryOffset = headerSize;
		foreach (var kvp in Directory) {
		    kvp.Value.Offset = directoryOffset;
		    kvp.Value.Index = (short) kvp.Key;
		    directoryOffset += kvp.Value.Size;
		}

                SetApplicationSpecificDirectoryDataSize();
		entryHeaderSize = DirectoryEntry.HeaderSize;
		directoryEntryBaseSize = DirectoryEntry.BaseSize;
		ParentChecksum = 0;
	    
		// write the header
		writer.Write(version);
		writer.Write(DataVersion);
		writer.WriteMacString(filename.Split('.')[0], maxFilename);
		writer.Write(checksum);
		writer.Write(directoryOffset);
		writer.Write((short) Directory.Count);
		writer.Write(applicationSpecificDirectoryDataSize);
		writer.Write(entryHeaderSize);
		writer.Write(directoryEntryBaseSize);
		writer.Write(ParentChecksum);
		writer.Write(new byte[2 * 20]);

		// write wads
		foreach (var kvp in Directory) {
		    kvp.Value.SaveChunks(writer, GetTagOrder());
		}

		// write directory
		foreach (var kvp in Directory) {
		    kvp.Value.SaveEntry(writer);
                    SaveApplicationSpecificDirectoryData(writer, kvp.Value.Index);
                }

		// fix the checksum!
		checksum = crcStream.GetCRC();
		fs.Seek(68, SeekOrigin.Begin);
		writer.Write(checksum);
	    }*/
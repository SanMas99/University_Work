#Major Assignment 1: Huffman Coding
#Sanad Masannat 1626221
#Fall 2019 CMPUT 274


import bitio
import huffman
import pickle



def read_tree(tree_stream):
    
    '''Read a description of a Huffman tree from the given compressed
    tree stream, and use the pickle module to construct the tree object.
    Then, return the root node of the tree itself.

    Args:
      tree_stream: The compressed stream to read the tree from.

    Returns:
      A Huffman tree root constructed according to the given description.
    '''
    return(pickle.load(tree_stream))#loads and returns tree

def decode_byte(tree, bitreader):


    """
    Reads bits from the bit reader and traverses the tree from
    the root to a leaf. Once a leaf is reached, bits are no longer read
    and the value of that leaf is returned.

    Args:
      bitreader: An instance of bitio.BitReader to read the tree from.
      tree: A Huffman tree.

    Returns:
      Next byte of the compressed bit stream.
    """
    end_of_File=False
    Tree=tree
    while end_of_File!=True:#Loops till flag is raised
        try:
            CurrentBit=bitreader.readbit()
            if CurrentBit==1:#Will go right if value is 1, left if 0
                Tree=Tree.getRight()
                if isinstance(Tree,huffman.TreeLeaf):
                    return Tree.getValue()
            else:
                Tree=Tree.getLeft()
                if isinstance(Tree,huffman.TreeLeaf):
                    return Tree.getValue()
        except EOFError:
            end_of_File = True
            print ("You have reached the end of the file")
        if isinstance(Tree,huffman.TreeLeaf):#checks to see if leaf is reached
        	return Tree.getValue()
    else:
        print ("End Of File reached")
        


def decompress(compressed, uncompressed):

    
    '''First, read a Huffman tree from the 'compressed' stream using your
    read_tree function. Then use that tree to decode the rest of the
    stream and write the resulting symbols to the 'uncompressed'
    stream.

    Args:
      compressed: A file stream from which compressed input is read.
      uncompressed: A writable file stream to which the uncompressed
          output is written.
    '''
    ReadingBit=bitio.BitReader(compressed)#Creates BitReaderInstance
    WritingBit=bitio.BitWriter(uncompressed)#Creates BitWeiterInstance
    ReadTree=read_tree(compressed)
    EndOfStream=False
    while EndOfStream!=True:#Loops till end is flagged
        try:
            Byte=decode_byte(ReadTree,ReadingBit)
        except EOFError:
            print ("You Have Reached The End Of The File")
            EndOfStream=True#Flags end
        WritingBit.writebits(Byte,8)
    WritingBit.flush()
    

def write_tree(tree, tree_stream):
    '''Write the specified Huffman tree to the given tree_stream
    using pickle.

    Args:
      tree: A Huffman tree.
      tree_stream: The binary file to write the tree to.
    '''
    pickle.dump(tree,tree_stream)#Writes tree to stream


def compress(tree, uncompressed, compressed):

    '''First write the given tree to the stream 'compressed' using the
    write_tree function. Then use the same tree to encode the data
    from the input stream 'uncompressed' and write it to 'compressed'.
    If there are any partially-written bytes remaining at the end,
    write 0 bits to form a complete byte.

    Flush the bitwriter after writing the entire compressed file.
    

    Args:
      tree: A Huffman tree.
      uncompressed: A file stream from which you can read the input.
      compressed: A file stream that will receive the tree description
          and the coded input data.
    '''
    EndFlag=False
    WriteBit=bitio.BitWriter(compressed)#Creates BitWriterInstance
    ReadBit=bitio.BitReader(uncompressed)#Creates BitReaderInstance
    write_tree(tree,compressed)
    Table=huffman.make_encoding_table(tree)#Makes a table via importing huffman.py
    while EndFlag!=True:
        try:
            CurrentByte=ReadBit.readbits(8)
            Key=Table[CurrentByte]
            for i in Key:
                WriteBit.writebit(i)
        except EOFError:#End is flagged
            EndFlag=True#Flag is set to true
            Key=Table[None]
            for i in Key:
                WriteBit.writebit(i)#Writes EoF symbol 
    WriteBit.flush()

import random

"""
Adapted from https://github.com/CalciferZh/AMCParser/blob/master/amc_parser.py
"""
def read_line(stream, idx):
    if idx >= len(stream):
        return None, idx
    line = stream[idx].strip().split()
    idx += 1
    return line, idx

def parse_amc(file_path):
    with open(file_path) as f:
        content = f.read().splitlines()

    for idx, line in enumerate(content):
        if line == ':DEGREES':
            content = content[idx+1:]
            break

    frames = []
    idx = 0
    line, idx = read_line(content, idx)
    assert line[0].isnumeric(), line
    EOF = False
    while not EOF:
        joint_degree = {}
        while True:
            line, idx = read_line(content, idx)
            if line is None:
                EOF = True
                break
            if line[0].isnumeric():
                break
            joint_degree[line[0]] = [float(deg) for deg in line[1:]]
        frames.append(joint_degree)
    return frames

def concatMoCap(input_filenames, n_transition_frames, out_filename):
    '''
    concatenate the input MoCap files in random order, 
    generate n_transition_frames transition frames using interpolation between every two MoCap files, 
    save the result as out_filename.
      parameter:
        input_filenames: [str], a list of all input filename strings
        n_transition_frames: int, number of transition frames
        out_filename: output file name
      return:
        None
    '''
    out= open(out_filename,"w", encoding='utf-8')
    index1=random.randint(0,len(input_filenames)-1)
    first=input_filenames[index1]
    index2=random.randint(0,len(input_filenames)-1)
    while index2==index1:
      index2=random.randint(0,len(input_filenames)-1)
    second=input_filenames[index2]
    index3=random.randint(0,len(input_filenames)-1)
    while index3==index1 or index3==index2:
      index3=random.randint(0,len(input_filenames)-1)
    third=input_filenames[index3]

    first_frames=parse_amc(first)
    second_frames=parse_amc(second)
    third_frames=parse_amc(third)
    out_frames=[]
    joints=list(first_frames[0].keys())
    #Loop through frames
    for i in range(0,len(first_frames)):
        out_frames.append(str(i+1))
        #Loop through the keys
        for j in range(0,len(joints)):
          string=""
          string=string+joints[j]+" "
          curr=first_frames[i][joints[j]]
          #Loop through points
          for k in range(0,len(curr)):
            curr_val=curr[k]
            if k == len(curr)-1:
              string=string+str(curr_val)
            else:
              string=string+str(curr_val)+" "
          out_frames.append(string)


    final_frame=list(first_frames[len(first_frames)-1].keys())
    next_frame=list(second_frames[0].keys())
    step=[]



    for i in range(0,len(final_frame)):
      curr=first_frames[-1][final_frame[i]]
      curr2=second_frames[0][final_frame[i]]
      join_arr=[]
      #Loop through points
      for k in range(0,len(curr)):
        curr_step=(curr2[k]-curr[k])/n_transition_frames
        join_arr.append(curr_step)
      step.append(join_arr)

    for i in range(n_transition_frames):
        out_frames.append(str(i+1+len(first_frames)))
        #Loop through the keys
        for j in range(0,len(joints)):
          string=""
          string=string+joints[j]+" "
          curr=first_frames[-1][joints[j]]
          #Loop through points
          for k in range(0,len(curr)):
            curr_val=curr[k]+step[j][k]*(i+1)
            if k == len(curr)-1:
              string=string+str(curr_val)
            else:
              string=string+str(curr_val)+" "
          out_frames.append(string)

    for i in range(0,len(second_frames)):
        out_frames.append(str(i+1+len(first_frames)+n_transition_frames))
        #Loop through the keys
        for j in range(0,len(joints)):
          string=""
          string=string+joints[j]+" "
          curr=second_frames[i][joints[j]]
          #Loop through points
          for k in range(0,len(curr)):
            curr_val=curr[k]
            if k == len(curr)-1:
              string=string+str(curr_val)
            else:
              string=string+str(curr_val)+" "
          out_frames.append(string)
     #interpolation here



    final_frame=list(first_frames[len(first_frames)-1].keys())
    next_frame=list(second_frames[0].keys())
    step=[]
    
    for i in range(0,len(final_frame)):
      curr=second_frames[-1][final_frame[i]]
      curr2=third_frames[0][final_frame[i]]
      join_arr=[]
      #Loop through points
      for k in range(0,len(curr)):
        curr_step=(curr2[k]-curr[k])/n_transition_frames
        join_arr.append(curr_step)
      step.append(join_arr)

    for i in range(n_transition_frames):
        out_frames.append(str(i+1+len(first_frames)+len(second_frames)))
        #Loop through the keys
        for j in range(0,len(joints)):
          string=""
          string=string+joints[j]+" "
          curr=second_frames[-1][joints[j]]
          #Loop through points
          for k in range(0,len(curr)):
            curr_val=curr[k]+step[j][k]*(i+1)
            if k == len(curr)-1:
              string=string+str(curr_val)
            else:
              string=string+str(curr_val)+" "
          out_frames.append(string)


    for i in range(0,len(third_frames)):
        out_frames.append(str(i+1+len(first_frames)+len(second_frames)+2*n_transition_frames))
        #Loop through the keys
        for j in range(0,len(joints)):
          string=""
          string=string+joints[j]+" "
          curr=third_frames[i][joints[j]]
          #Loop through points
          for k in range(0,len(curr)):
            curr_val=curr[k]
            if k == len(curr)-1:
              string=string+str(curr_val)
            else:
              string=string+str(curr_val)+" "
          out_frames.append(string)
    out.write(":FULLY-SPECIFIED"+"\n")
    out.write(":DEGREES"+"\n")
    for line in out_frames:
      out.write(line+"\n")
    out.close()
def main():
  input=["85_01.amc","85_08.amc","85_10.amc"]
  output="combined.amc"
  n=100
  concatMoCap(input, n, output)




if __name__ == "__main__":
    main()
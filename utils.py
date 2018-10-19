import tensorflow as tf


def mask_busy_gpus(leave_unmasked=1, random=True):
  try:
    command = "nvidia-smi --query-gpu=memory.free --format=csv"
    memory_free_info = _output_to_list(sp.check_output(command.split()))[1:]
    memory_free_values = [int(x.split()[0]) for i, x in enumerate(memory_free_info)]
    available_gpus = [i for i, x in enumerate(memory_free_values) if x > ACCEPTABLE_AVAILABLE_MEMORY]

    if len(available_gpus) < leave_unmasked:
      print('Found only %d usable GPUs in the system' % len(available_gpus))
      exit(0)

    if random:
      available_gpus = np.asarray(available_gpus)
      np.random.shuffle(available_gpus)

    # update CUDA variable
    gpus = available_gpus[:leave_unmasked]
    setting = ','.join(map(str, gpus))
    os.environ["CUDA_VISIBLE_DEVICES"] = setting
    print('Left next %d GPU(s) unmasked: [%s] (from %s available)'
          % (leave_unmasked, setting, str(available_gpus)))
  except FileNotFoundError as e:
    print('"nvidia-smi" is probably not installed. GPUs are not masked')
    print(e)
  except sp.CalledProcessError as e:
    print("Error on GPU masking:\n", e.output)
    
    
def _output_to_list(output):
  return output.decode('ascii').split('\n')[:-1]


def reset_graph():
  """reset your graph when you build a new one"""
  tf.reset_default_graph()


def get_op(name):
  """
    Get an operation by its name
    
    :param name: operation name 'tower1/operation' or similar tensorname 'tower1/operation:0'
    :return: tensorflow.Operation
  """
  if ':' in name: name = name.split(':')[0]
  tf.get_default_graph().get_operation_by_name(name) 


def graph_meta_to_text(path, output=None):
  """
  Convert graph meta to text
  """
  if not output: output = path + 'txt'
  with tf.Session(config=tf.ConfigProto(allow_soft_placement=True)) as sess:
    tf.train.import_meta_graph(path)
    tf.train.export_meta_graph(output, as_text=True)
 

def checkpoint_list_vars(chpnt):
  """
  Given path to a checkpoint list all variables available in the checkpoint
  """
  from tensorflow.contrib.framework.python.framework import checkpoint_utils
  var_list = checkpoint_utils.list_variables(chpnt)
  for v in var_list: print(v)
  return var_list

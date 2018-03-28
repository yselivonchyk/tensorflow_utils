import tensorflow as tf


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
 

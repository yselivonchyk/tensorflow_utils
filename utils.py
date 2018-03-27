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

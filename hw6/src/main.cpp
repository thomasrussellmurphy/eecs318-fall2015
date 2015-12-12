#include <array>
#include <cstdio>
#include <fstream>
#include <iostream>
#include <map>
#include <queue>
#include <set>
#include <string>
#include <unordered_map>

// Structure: type, output flag, level, fan-in (list), fan-out(list), name string
// List is count and array of pointers/integers

typedef enum class Gate_operation
{
  AND,
  OR,
  NAND,
  NOR,
  XOR,
  XNOR,
  NOT,
  DFF,
  BUF,
  INPUT,
  OUTPUT,
  INVALID
} Gate_Op_t;

class Gate_state
{
  public:

  // States are two-bit encoded
  // Value 2 should be reverted to sX
  static const int s0 = 0;  // 2'b00
  static const int s1 = 3;  // 2'b11
  static const int sX = 1;  // 2'b01
};

class Gate_eval
{
  public:

  // Gates are hard-coded against Gate_state values
  static int AND[4][4];
  static int OR[4][4];
  static int NAND[4][4];
  static int NOR[4][4];
  static int NOT[4];
};

int Gate_eval::AND[4][4] = {
  {Gate_state::s0, Gate_state::s0, Gate_state::sX, Gate_state::s0},
  {Gate_state::s0, Gate_state::sX, Gate_state::sX, Gate_state::sX},
  {Gate_state::sX, Gate_state::sX, Gate_state::sX, Gate_state::sX},
  {Gate_state::s0, Gate_state::sX, Gate_state::sX, Gate_state::s1},
  };

int Gate_eval::OR[4][4] = {
  {Gate_state::s0, Gate_state::sX, Gate_state::sX, Gate_state::s1},
  {Gate_state::sX, Gate_state::sX, Gate_state::sX, Gate_state::s1},
  {Gate_state::sX, Gate_state::sX, Gate_state::sX, Gate_state::sX},
  {Gate_state::s1, Gate_state::s1, Gate_state::sX, Gate_state::s1},
  };

int Gate_eval::NAND[4][4] = {
  {Gate_state::s1, Gate_state::s1, Gate_state::sX, Gate_state::s1},
  {Gate_state::s1, Gate_state::sX, Gate_state::sX, Gate_state::sX},
  {Gate_state::sX, Gate_state::sX, Gate_state::sX, Gate_state::sX},
  {Gate_state::s1, Gate_state::sX, Gate_state::sX, Gate_state::s0},
  };

int Gate_eval::NOR[4][4] = {
  {Gate_state::s1, Gate_state::sX, Gate_state::sX, Gate_state::s0},
  {Gate_state::sX, Gate_state::sX, Gate_state::sX, Gate_state::s0},
  {Gate_state::sX, Gate_state::sX, Gate_state::sX, Gate_state::sX},
  {Gate_state::s0, Gate_state::s0, Gate_state::sX, Gate_state::s0},
  };

int Gate_eval::NOT[4] =
  {Gate_state::s1, Gate_state::sX, Gate_state::sX, Gate_state::s0};

const char* Gate_names[] = {"AND", "OR", "NAND", "NOR", "XOR", "XNOR", "NOT", "DFF", "BUF", "INPUT", "OUTPUT"};

Gate_Op_t enumify_operation(std::string s)
{
  if(s == Gate_names[0])
  {
    return Gate_operation::AND;
  }
  if(s == Gate_names[1])
  {
    return Gate_operation::OR;
  }
  if(s == Gate_names[2])
  {
    return Gate_operation::NAND;
  }
  if(s == Gate_names[3])
  {
    return Gate_operation::NOR;
  }
  if(s == Gate_names[4])
  {
    return Gate_operation::XOR;
  }
  if(s == Gate_names[5])
  {
    return Gate_operation::XNOR;
  }
  if(s == Gate_names[6])
  {
    return Gate_operation::NOT;
  }
  if(s == Gate_names[7])
  {
    return Gate_operation::DFF;
  }
  if(s == Gate_names[8])
  {
    return Gate_operation::BUF;
  }

  // DOES NOT directly process the I/O gate cases here

  // Default value
  return Gate_operation::INVALID;
}

std::string stringify_operation(Gate_Op_t op)
{
  switch(op)
  {
    case Gate_operation::AND:
      return Gate_names[0];
    case Gate_operation::OR:
      return Gate_names[1];
    case Gate_operation::NAND:
      return Gate_names[2];
    case Gate_operation::NOR:
      return Gate_names[3];
    case Gate_operation::XOR:
      return Gate_names[4];
    case Gate_operation::XNOR:
      return Gate_names[5];
    case Gate_operation::NOT:
      return Gate_names[6];
    case Gate_operation::DFF:
      return Gate_names[7];
    case Gate_operation::BUF:
      return Gate_names[8];
    case Gate_operation::INPUT:
      return Gate_names[9];
    case Gate_operation::OUTPUT:
      return Gate_names[10];
    default:
      return "INVALID GATE";
  }
}

typedef struct Gate
{
  Gate_Op_t op;
  int level;
  int state;
  int dff_state;
  std::set<Gate*> fan_in;
  std::set<Gate*> fan_out;
  std::string name;
} Gate_t;

bool is_input_line(std::string line)
{
  return line.find("INPUT") == 0;
}

bool is_output_line(std::string line)
{
  return line.find("OUTPUT") == 0;
}

bool is_gate_line(std::string line)
{
  return line.find(" = ") != std::string::npos;
}

Gate_t* get_or_make_gate(std::unordered_map<std::string, Gate_t*>* gates, std::string name)
{
  Gate_t* gate = NULL;

  // Check if this gate has been created already
  if(gates->count(name))
  {
    gate = gates->at(name);
  } else
  {
    // Create and setup the new gate
    gate = new(Gate_t);
    gate->name = name;
    gate->op = Gate_operation::INVALID;
    gate->level = -1;
    gate->state = Gate_state::sX;
    gate->dff_state = Gate_state::sX;
    gates->insert(std::pair<std::string, Gate_t*>(name, gate));
  }

  return gate;
}

void add_input_net_to_gate(std::unordered_map<std::string, Gate_t*>* gates, Gate_t* gate, std::string input_net)
{
  Gate_t* input_gate = get_or_make_gate(gates, input_net);

  gate->fan_in.insert(input_gate);
  input_gate->fan_out.insert(gate);
}

int eval_table(Gate_t* gate)
{
  std::vector<int> input_states;
  for(Gate_t* input : gate->fan_in)
  {
    input_states.push_back(input->state);
  }

  switch(gate->op)
  {
    case Gate_operation::AND:
      return Gate_eval::AND[input_states[0]][input_states[1]];
    case Gate_operation::OR:
      return Gate_eval::OR[input_states[0]][input_states[1]];
    case Gate_operation::NAND:
      return Gate_eval::NAND[input_states[0]][input_states[1]];
    case Gate_operation::NOR:
      return Gate_eval::NOR[input_states[0]][input_states[1]];
    case Gate_operation::NOT:
      return Gate_eval::NOT[input_states[0]];
    case Gate_operation::BUF:
    case Gate_operation::OUTPUT:
      return input_states[0];
    default:
      std::cerr << "Attempted to evaluate not-implemented gate" << std::endl;
      return Gate_state::sX;
    }
}

int eval_scan(Gate_t* gate)
{
  int control = Gate_state::s0;
  bool inversion = false;

  switch(gate->op)
  {
    case Gate_operation::AND:
      control = Gate_state::s0;
      inversion = false;
      break;
    case Gate_operation::OR:
      control = Gate_state::s1;
      inversion = false;
      break;
    case Gate_operation::NAND:
      control = Gate_state::s0;
      inversion = true;
      break;
    case Gate_operation::NOR:
      control = Gate_state::s1;
      inversion = true;
      break;
    case Gate_operation::NOT:
      // Invert the only fan_in gate to get the new state
      for(Gate_t* source : gate->fan_in)
      {
        return Gate_eval::NOT[source->state];
      }
    case Gate_operation::BUF:
    case Gate_operation::OUTPUT:
      // Pass the only fan_in gate to the new state
      for(Gate_t* source : gate->fan_in)
      {
        return source->state;
      }
    default:
      std::cerr << "Attempted to evaluate not-implemented gate" << std::endl;
      return Gate_state::sX;
  }


  bool unknown_input = false;
  for(Gate_t* input : gate->fan_in)
  {
    if(input->state == control)
    {
      return inversion ? Gate_eval::NOT[control] : control ;
    }
    if(input->state == Gate_state::sX)
    {
      unknown_input = true;
    }
  }

  if(unknown_input)
  {
    return Gate_state::sX;
  } else {
    // Piles of confusing double-negatives, yo
    return inversion ? control : Gate_eval::NOT[control] ;
  }
}

int main(int argc, char *argv[])
{
  if(argc == 1) {
    std::cerr << "No argument file to open." << std::endl;
    std::exit(0);
  }

  // Get filename argument for which netlist input to load
  std::ifstream source(argv[1]);

  if(!source.is_open())
  {
    std::cerr << "Failed to open source file." << std::endl;
    std::exit(1);
  }

  // Need to parse the incoming netlist

  // Sequence usually: Comments, free Inputs, defined Outputs, Gate objects
  // Each line is a single instance
  // Comment: "#<comment text>"
  // Input: "INPUT(<netname>)"
  // Output: "OUTPUT(<netname>)"
  // Gate: "<netname> = GATE(<netname>, <netname>)"

  std::string line;
  std::set<std::string> input_nets;
  std::set<std::string> output_nets;
  std::set<std::string> dff_gates;

  std::unordered_map<std::string, Gate_t*> gates;

  // Input processing loop, line-by-line
  while(getline(source, line))
  {
    // Skip-line cases
    if(line.empty())
    {
      // cout << "empty line" << std::endl;
      continue;
    }
    if(line[0] == '#')
    {
      // cout << "comment line" << std::endl;
      continue;
    }

    // Processing each of the line types (mutually exclusive)
    if(is_input_line(line))
    {
      size_t start = line.find("(") + 1;
      size_t len = line.find(")") - start;
      std::string net_name = line.substr(start, len);
      input_nets.insert(net_name);

      Gate_t* input_gate = get_or_make_gate(&gates, net_name);
      input_gate->op = Gate_operation::INPUT;
    }

    if(is_output_line(line))
    {
      size_t start = line.find("(") + 1;
      size_t len = line.find(")") - start;
      std::string net_name = line.substr(start, len);
      output_nets.insert(net_name);
      // These will be complete gates
    }

    if(is_gate_line(line))
    {
      size_t first_space = line.find(" ");
      std::string out_net = line.substr(0, first_space);
      line.erase(0, first_space + 1);

      // Check if this gate has been created due to fan in/out of another gate
      Gate_t* gate = get_or_make_gate(&gates, out_net);

      size_t gate_op_start = line.find(" ") + 1;
      size_t gate_op_len = line.find("(") - gate_op_start;
      std::string gate_op_name = line.substr(gate_op_start, gate_op_len);
      line.erase(0, gate_op_start + gate_op_len + 1);

      // use gate_type to set the gate's operation
      Gate_Op_t gate_op = enumify_operation(gate_op_name);
      if(gate_op == Gate_operation::INVALID)
      {
        std::cerr << "invalid gate: " << gate_op_name << std::endl;
      }
      gate->op = gate_op;

      if(gate_op == Gate_operation::DFF)
      {
        dff_gates.insert(out_net);
      }

      // Now to handle the gate input(s)
      if(line.find(", ") != std::string::npos)
      {
        // Two inputs
        size_t comma = line.find(", ");
        std::string in_net1 = line.substr(0, comma);
        line.erase(0, comma);

        // Substring starting at 2 eats the  ", "
        size_t close_paren = line.find(")");
        std::string in_net2 = line.substr(2, close_paren - 2);

        // Done string processing

        add_input_net_to_gate(&gates, gate, in_net1);
        add_input_net_to_gate(&gates, gate, in_net2);
      } else
      {
        // One input
        size_t close_paren = line.find(")");
        std::string in_net = line.substr(0, close_paren);

        // Done string processing

        add_input_net_to_gate(&gates, gate, in_net);
      }
    }
  }
  // Done with reading the source file
  source.close();

  // Create outputs
  for(std::string output_net_name : output_nets)
  {
    std::string output_gate_name = output_net_name + "_out";
    Gate_t* output_gate = get_or_make_gate(&gates, output_gate_name);

    add_input_net_to_gate(&gates, output_gate, output_net_name);
    output_gate->op = Gate_operation::OUTPUT;
  }

  // Process circuit to add buffers on gates with fanout >1
  std::set<std::string> gates_with_fanout;
  for(std::pair<std::string, Gate_t*> gate_pair : gates)
  {
    if(gate_pair.second->fan_out.size() > 1)
    {
      gates_with_fanout.insert(gate_pair.first);
    }
  }

  for(std::string fanout_gate : gates_with_fanout)
  {
    Gate_t* source_gate = get_or_make_gate(&gates, fanout_gate);

    std::set<Gate_t*> buffered_fanout;

    // Insertion of buffer into the fanout net
    for(Gate_t* destination : source_gate->fan_out)
    {
      std::string buf_name = "BUF-" + source_gate->name + "-" + destination->name;

      // Setup the new buffer
      Gate_t* buf = get_or_make_gate(&gates, buf_name);
      buf->op = Gate_operation::BUF;
      buf->fan_in.insert(source_gate);

      // Swap in buffer on the destination side
      buffered_fanout.insert(buf);
      destination->fan_in.erase(source_gate);
      add_input_net_to_gate(&gates, destination, buf_name);
    }

    // Swap in all of the new buffers on the source side
    source_gate->fan_out.swap(buffered_fanout);
  }

  // Taking care of setting levels
  std::queue<std::string> gates_needing_level_propogation;

  // Set inputs as level zero
  for(std::string input_gate_name : input_nets)
  {
    Gate_t* input_gate = gates.at(input_gate_name);
    input_gate->level = 0;
    gates_needing_level_propogation.push(input_gate_name);
  }

  // Set DFFs as level zero
  for(std::string dff_gate_name : dff_gates)
  {
    Gate_t* dff_gate = gates.at(dff_gate_name);
    dff_gate->level = 0;

    gates_needing_level_propogation.push(dff_gate_name);
  }

  while(!gates_needing_level_propogation.empty())
  {
    std::string gate_name = gates_needing_level_propogation.front();
    gates_needing_level_propogation.pop();

    Gate_t* gate = get_or_make_gate(&gates, gate_name);

    for(Gate_t* child : gate->fan_out)
    {
      // We need to set the level of any encountered non-DFF children gates
      if(child->op != Gate_operation::DFF)
      {
        child->level = gate->level + 1;
        gates_needing_level_propogation.push(child->name);
      }
    }
  }

  // REQUIREMENT 1: total number of gates after processing
  std::cout << "Total processed gates, inputs, and outputs: ";
  std::cout << gates.size() << std::endl;

  // REQUIREMENT 2: number of gates at each level
  std::map<int, int> levels_count;
  for(std::pair<std::string, Gate_t*> gate_pair : gates)
  {
    int level = gate_pair.second->level;

    if(levels_count.count(level))
    {
      levels_count.at(level) += 1;
    } else
    {
      levels_count.insert(std::pair<int, int>(level, 1));
    }
  }

  for(std::pair<int, int> level_count_pair : levels_count)
  {
    std::cout << "Level " << level_count_pair.first << ": ";
    std::cout << level_count_pair.second << std::endl;
  }

  // REQUIREMENT 3: listing of whole circuit
  for(std::pair<std::string, Gate_t*> gate_pair : gates)
  {
    Gate_t* gate = gate_pair.second;
    std::cout << "Gate: " << gate->name << std::endl;

    std::cout << "  Type: " << stringify_operation(gate->op) << std::endl;

    std::cout << "  Inputs: ";
    for(Gate_t* input : gate->fan_in)
    {
      std::cout << input->name << " ";
    }

    std::cout << std::endl;

    std::cout << "  Outputs: ";
    for(Gate_t* output : gate->fan_out)
    {
      std::cout << output->name << " ";
    }

    std::cout << std::endl;

    std::cout << "  Level: " << gate->level;

    std::cout << std::endl;
  }
}

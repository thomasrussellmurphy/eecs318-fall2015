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
  INVALID
} Gate_Op_t;

const char* Gate_names[] = {"AND", "OR", "NAND", "NOR", "XOR", "XNOR", "NOT", "DFF", "BUF"};

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
    default:
      return "INVALID GATE";
  }
}

typedef struct Gate
{
  Gate_Op_t op;
  int level;
  std::set<Gate*> fan_in;
  std::set<Gate*> fan_out;
  std::string name;
  std::string op_name;
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
    gate->level = -1;
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
      // These will be unnamed gates with zero fan-in
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
        std::cout << "invalid gate: " << gate_op_name << std::endl;
      }
      gate->op = gate_op;
      gate->op_name = gate_op_name;

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

  // Create output buffers
  for(std::string output_net_name : output_nets)
  {
    std::string output_gate_name = output_net_name + "_out";
    Gate_t* output_gate = get_or_make_gate(&gates, output_gate_name);

    add_input_net_to_gate(&gates, output_gate, output_net_name);
    output_gate->op = Gate_operation::BUF;
    output_gate->op_name = "BUF";

    std::cout << "Output: " << output_gate->name << std::endl;
  }

  // Process circuit to add buffers on gates with fanout >1
  std::set<std::string> gates_with_fanout;
  for(std::pair<std::string, Gate_t*> gate_pair : gates)
  {
    if(gate_pair.second->fan_out.size() > 1)
    {
      gates_with_fanout.insert(gate_pair.first);
      std::cout << "Gate with fanout " << gate_pair.second->fan_out.size();
      std::cout << ": " << gate_pair.first << std::endl;
    }
  }

  for(std::string fanout_gate : gates_with_fanout)
  {
    Gate_t* source_gate = get_or_make_gate(&gates, fanout_gate);

    std::set<Gate_t*> buffered_fanout;

    for(Gate_t* destination : source_gate->fan_out)
    {
      std::string buf_name = "BUF-" + source_gate->name + "-" + destination->name;
      Gate_t* buf = get_or_make_gate(&gates, buf_name);
      buffered_fanout.insert(buf);
      destination->fan_in.erase(source_gate);
      add_input_net_to_gate(&gates, destination, buf_name);
    }

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
      if(child->op != Gate_operation::DFF)
      {
        child->level = gate->level + 1;
        gates_needing_level_propogation.push(child->name);
      }
    }
  }

  // REQUIREMENT 1: total number of gates after processing
  std::cout << "Total initial gates+inputs: " << gates.size() << std::endl;

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

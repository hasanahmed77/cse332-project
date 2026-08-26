//
// Created by Sajeeb on 3/15/25.
//

#include <unordered_set>
#include <string>
#include <memory>
#include <vector>
#include <functional>
#include <stddef.h>
#include <stdint.h>

//#include "mips.h"

#ifndef MIPSASSEMBLER_DATA_SYMBOL_TABLE_H
#define MIPSASSEMBLER_DATA_SYMBOL_TABLE_H

using std::unordered_set;
using std::string;


// for keeping track of MIPS directives supported in SPIM simulator
enum class BindingType {
    WORD,       // Allocates one or more 32-bit (4-byte) words.
    ASCII,      // Stores a string without a null terminator.
    ASCIIZ,     // Stores a string with a null terminator (\0).
    EQU,        // Defines a constant value (like #define in C).
    DOUBLE,     // Allocates one or more 64-bit floating-point values.
    FLOAT,      // Allocates one or more 32-bit floating-point values.
    HALF,       // Allocates one or more 16-bit (2-byte) halfwords.
    SPACE,      // Reserves n bytes of memory (initialized to zero).
    BYTE,       // Allocates one or more 8-bit bytes.
    ALIGN,      // Aligns the next data item to a 2^n byte boundary.
    NONE        // Placeholder
};

// Base classes
class BindingTypeVisitorBase;
class CodegenVisitorBase;
class WordBinding;
class AsciiBinding;
class AsciizBinding;
class EquBinding;
class DoubleBinding;
class FloatBinding;
class HalfBinding;
class SpaceBinding;
class ByteBinding;
class AlignBinding;
class BindingVisitor;


class BindingTypeBase {
public:
    virtual ~BindingTypeBase() = default;
    virtual void describe() const = 0;
    virtual void accept(CodegenVisitorBase*) = 0;
};
class CodegenVisitorBase {
public:
    virtual void visit(WordBinding*) = 0;
    virtual void visit(AsciiBinding*) = 0;
    virtual void visit(AsciizBinding*) = 0;
    virtual void visit(EquBinding*) = 0;
    virtual void visit(DoubleBinding*) = 0;
    virtual void visit(FloatBinding*) = 0;
    virtual void visit(HalfBinding*) = 0;
    virtual void visit(SpaceBinding*) = 0;
    virtual void visit(ByteBinding*) = 0;
    virtual void visit(AlignBinding*) = 0;
};



// Derived classes for each binding type
class WordBinding : public BindingTypeBase {
public:
    int value = 0;

    WordBinding(int value = -1) : value(value) {}
    void describe() const override {
        std::cout << ".word. value: "
                  << value << std::endl;
    }
    void accept(CodegenVisitorBase* visitor) override {
        visitor->visit(this);
    }
};

class AsciiBinding : public BindingTypeBase {
public:
    std::string value;

    AsciiBinding(std::string value = "") : value(value) {}
    void describe() const override {
        std::cout << "Stores a string without a null terminator.\n";
    }
    void accept(CodegenVisitorBase* visitor) override {
        visitor->visit(this);
    }
};

class AsciizBinding : public BindingTypeBase {
public:
    std::string value;

    AsciizBinding(std::string value = "") : value(value) {}
    void describe() const override {
        std::cout << ".asciiz. value: " << value << std::endl;
    }
    void accept(CodegenVisitorBase* visitor) override {
        visitor->visit(this);
    }
};

class EquBinding : public BindingTypeBase {
public:
    EquBinding() {}
    void describe() const override {
        std::cout << "Defines a constant value (like #define in C).\n";
    }
    void accept(CodegenVisitorBase* visitor) override {
        visitor->visit(this);
    }
};

class DoubleBinding : public BindingTypeBase {
public:
    double value = 0.0;

    DoubleBinding(double value = 0.0) : value(value) {}
    void describe() const override {
        std::cout << "Allocates one or more 64-bit floating-point values.\n";
    }
    void accept(CodegenVisitorBase* visitor) override {
        visitor->visit(this);
    }
};

class FloatBinding : public BindingTypeBase {
public:
    float value = 0.0f;

    FloatBinding(float value = 0.0) : value(value) {}
    void describe() const override {
        std::cout << "Allocates one or more 32-bit floating-point values.\n";
    }
    void accept(CodegenVisitorBase* visitor) override {
        visitor->visit(this);
    }
};

class HalfBinding : public BindingTypeBase {
public:
    // https://stackoverflow.com/questions/73873870/is-the-half-a-native-c-type
    short value;
    HalfBinding(short value = 0.0) : value(value) {}
    void describe() const override {
        std::cout << "Allocates one or more 16-bit (2-byte) halfwords.\n";
    }
    void accept(CodegenVisitorBase* visitor) override {
        visitor->visit(this);
    }
};

class SpaceBinding : public BindingTypeBase {
public:
    int value;
    SpaceBinding(int value = 0.0) : value(value) {}
    void describe() const override {
        std::cout << ".space. value:  "<< value << "\n";
    }
    void accept(CodegenVisitorBase* visitor) override {
        visitor->visit(this);
    }
};

class ByteBinding : public BindingTypeBase {
public:
    int value;
    ByteBinding(int value = 0.0) : value(value) {}
    void describe() const override {
        std::cout << "Allocates one or more 8-bit bytes.\n";
    }
    void accept(CodegenVisitorBase* visitor) override {
        visitor->visit(this);
    }
};

class AlignBinding : public BindingTypeBase {
public:
    int value;
    AlignBinding(int value = 0.0) : value(value) {}
    void describe() const override {
        std::cout << "Aligns the next data item to a 2^n byte boundary.\n";
    }
    void accept(CodegenVisitorBase* visitor) override {
        visitor->visit(this);
    }
};


class DataSegmentCodegenVisitor : public CodegenVisitorBase {
    std::string padLeft(const std::string& bitString, size_t length) {
        if (bitString.length() >= length) return bitString;
        return std::string(length - bitString.length(), '0') + bitString;
    }

    void add_code(const std::string& str) {
        code += str;
        code += "\n";
    }

public:
    std::string code = "";
    
    void visit(WordBinding* obj) override {
        add_code(padLeft(decToBinary(obj->value), 32));
    }
    void visit(AsciiBinding* obj) override {
        uint32_t word = 0;
        uint8_t byte_count = 0;

        for (size_t i = 0; i < obj->value.size(); ++i) {
            char c = obj->value[i];

            if (c == '"') {
                if (i == 0) continue; // skip opening quote
                if (obj->value[i - 1] == '\\') {
                    // escaped quote
                    word |= (static_cast<uint32_t>('"') << ((3 - byte_count) * 8));
                    byte_count++;
                    if (byte_count == 4) {
                        add_code(padLeft(decToBinary(word), 32));
                        word = 0;
                        byte_count = 0;
                    }
                }
                continue; // ignore unescaped quote
            }

            if (c == '\\') {
                if (i + 1 < obj->value.size()) {
                    char next = obj->value[i + 1];
                    uint8_t ascii_val = 0;
                    switch (next) {
                        case 'n': ascii_val = '\n'; break;
                        case 't': ascii_val = '\t'; break;
                        case 'r': ascii_val = '\r'; break;
                        case '\\': ascii_val = '\\'; break;
                        case '\'': ascii_val = '\''; break;
                        case '"': ascii_val = '"'; break;
                        case '0': ascii_val = '\0'; break;
                        default: ascii_val = next; break; // unrecognized escape
                    }
                    word |= (static_cast<uint32_t>(ascii_val) << ((3 - byte_count) * 8));
                    byte_count++;
                    if (byte_count == 4) {
                        add_code(padLeft(decToBinary(word), 32));
                        word = 0;
                        byte_count = 0;
                    }
                    ++i; // skip the next character
                    continue;
                }
            }

            // Normal character
            word |= (static_cast<uint32_t>(c) << ((3 - byte_count) * 8));
            byte_count++;
            if (byte_count == 4) {
                add_code(padLeft(decToBinary(word), 32));
                word = 0;
                byte_count = 0;
            }
        }

        // After the loop, if there are any leftover bytes, still flush them
        if (byte_count > 0) {
            add_code(padLeft(decToBinary(word), 32));
        }
    }
    void visit(AsciizBinding* obj) override {
        uint32_t word = 0;
        uint8_t byte_count = 0;

        for (size_t i = 0; i < obj->value.size(); ++i) {
            char c = obj->value[i];

            if (c == '"') {
                if (i == 0) continue; // skip opening quote
                if (obj->value[i - 1] == '\\') {
                    // escaped quote
                    word |= (static_cast<uint32_t>('"') << ((3 - byte_count) * 8));
                    byte_count++;
                    if (byte_count == 4) {
                        add_code(padLeft(decToBinary(word), 32));
                        word = 0;
                        byte_count = 0;
                    }
                }
                continue; // ignore unescaped quote
            }

            if (c == '\\') {
                if (i + 1 < obj->value.size()) {
                    char next = obj->value[i + 1];
                    uint8_t ascii_val = 0;
                    switch (next) {
                        case 'n': ascii_val = '\n'; break;
                        case 't': ascii_val = '\t'; break;
                        case 'r': ascii_val = '\r'; break;
                        case '\\': ascii_val = '\\'; break;
                        case '\'': ascii_val = '\''; break;
                        case '"': ascii_val = '"'; break;
                        case '0': ascii_val = '\0'; break;
                        default: ascii_val = next; break; // unrecognized escape
                    }
                    word |= (static_cast<uint32_t>(ascii_val) << ((3 - byte_count) * 8));
                    byte_count++;
                    if (byte_count == 4) {
                        add_code(padLeft(decToBinary(word), 32));
                        word = 0;
                        byte_count = 0;
                    }
                    ++i; // skip the next character
                    continue;
                }
            }

            // Normal character
            word |= (static_cast<uint32_t>(c) << ((3 - byte_count) * 8));
            byte_count++;
            if (byte_count == 4) {
                add_code(padLeft(decToBinary(word), 32));
                word = 0;
                byte_count = 0;
            }
        }

        // After the loop, if there are any leftover bytes, still flush them
        if (byte_count > 0) {
            add_code(padLeft(decToBinary(word), 32));
        }
        add_code(padLeft(decToBinary(0), 32));
    }
    void visit(EquBinding*) override {}
    void visit(DoubleBinding*) override {}
    void visit(FloatBinding*) override {}
    void visit(HalfBinding*) override {}

    void visit(SpaceBinding* obj) override {
        for (int i=0; i<obj->value; ++i)
            add_code(padLeft(decToBinary(0), 32));
    }

    void visit(ByteBinding*) override {}
    void visit(AlignBinding*) override {}
};


struct BindingInformation {
    std::vector<std::unique_ptr<BindingTypeBase>> _types;
    int offset;
};

struct SymbolTableEntry {
    string _symbol_name; // will most likely be labels including for .equ statements
    BindingInformation _binding_information;

    bool operator==(const SymbolTableEntry& rhs) const {
        return _symbol_name == rhs._symbol_name;
    }
};

namespace std {
    template <>
    struct hash<SymbolTableEntry> {
        size_t operator()(const SymbolTableEntry& entry) const {
            return hash<string>()(entry._symbol_name);
        }
    };
}

// A symbol table for data section machine code generation
class DataSymbolTable final {
public:
    unordered_set<SymbolTableEntry> entries;
    std::vector<std::string> _insertion_order; // to impose an ordering during iteration
    string _last_inserted_label;

    void add_entry(string& label) {
        _last_inserted_label = label;
        _insertion_order.push_back(label);
        entries.insert({label, {{}, -1}});
    }

    BindingInformation& operator[](const std::string& symbol) {
        static SymbolTableEntry not_found_entry{"", {{}, -1}};
        SymbolTableEntry temp_entry{symbol, {{}, -1}};
        auto it = entries.find(temp_entry);
        return const_cast<BindingInformation&>(it->_binding_information);  // Return reference to the found entry
    }

    void print() const {
        for (const auto& entry : entries) {
            std::cout << "Symbol: " << entry._symbol_name << "\n";
            std::cout << "Offset: " << entry._binding_information.offset << "\n";
            std::cout << "Bindings:\n";

            for (const auto& binding : entry._binding_information._types) {
                binding->describe();
            }

            std::cout << "----------------------\n";
        }
    }
};


// A map between BindingType enumeration values and its actual type in C++
template <BindingType type>
struct BindingTypeMap;

// Specialize for each binding type
template <>
struct BindingTypeMap<BindingType::WORD> { using type = WordBinding; };

template <>
struct BindingTypeMap<BindingType::ASCII> { using type = AsciiBinding; };

template <>
struct BindingTypeMap<BindingType::ASCIIZ> { using type = AsciizBinding; };

template <>
struct BindingTypeMap<BindingType::EQU> { using type = EquBinding; };

template <>
struct BindingTypeMap<BindingType::DOUBLE> { using type = DoubleBinding; };

template <>
struct BindingTypeMap<BindingType::FLOAT> { using type = FloatBinding; };

template <>
struct BindingTypeMap<BindingType::HALF> { using type = HalfBinding; };

template <>
struct BindingTypeMap<BindingType::SPACE> { using type = SpaceBinding; };

template <>
struct BindingTypeMap<BindingType::BYTE> { using type = ByteBinding; };

template <>
struct BindingTypeMap<BindingType::ALIGN> { using type = AlignBinding; };

template <BindingType type, typename... Args>
std::unique_ptr<BindingTypeBase> createBinding(Args&&... args) {
    using BindingClass = typename BindingTypeMap<type>::type;
    return std::make_unique<BindingClass>(std::forward<Args>(args)...);
}




#endif //MIPSASSEMBLER_DATA_SYMBOL_TABLE_H

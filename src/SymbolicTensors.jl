module SymbolicTensors

using SymPy
using PyCall

import SymPy: SymbolicObject,Sym,diff,jprint

import Base: show
import Base: convert, promote_rule
import Base: getproperty
import Base: hash, ==
import Base: length, size
import Base.iterate
import Base: +, -, *, /, //, \, ^, log

export TensorIndexType, tensor_indices, TensorIndex, TensorHead
export IndexedTensor, TensAdd, TensMul, TensScalar
export TensorSymmetry
#export @heads,@indices
export @indices, @heads
export tensor
export diff
export canon_bp, contract_metric
export get_tsymmetry
export scalarIsEqual

abstract type Tensor <: SymbolicObject end
struct TensorIndex <: SymbolicObject
    __pyobject__::PyCall.PyObject
end
struct TensorIndexType <: SymbolicObject
    __pyobject__::PyCall.PyObject
end
struct TensorSymmetry <: SymbolicObject
    __pyobject__::PyCall.PyObject
end
struct TensorHead <: SymbolicObject
    __pyobject__::PyCall.PyObject
end

#struct TensScalar <: Tensor
#    var::Sym;
#    expr::Sym;
#    __pyobject__::PyCall.PyObject;
#end

struct TensMul <: Tensor
    __pyobject__::PyCall.PyObject
end
struct TensAdd <: Tensor
    __pyobject__::PyCall.PyObject
end
struct IndexedTensor <: Tensor
    __pyobject__::PyCall.PyObject
end

const tensor = PyCall.PyNULL()
const toperations = PyCall.PyNULL()
const get_tsymmetry = convert(TensorSymmetry,PyCall.PyNULL())

function __init__()
    copy!(tensor,PyCall.pyimport_conda("sympy.tensor.tensor","sympy"))
    copy!(get_tsymmetry.__pyobject__,tensor.TensorSymmetry)
    #pytype_mapping(tensor.TensorSymmetry,TensorSymmetry)
#    copy!(toperations,PyCall.pyimport_conda("sympy.tensor.toperations","sympy"))
end

function sympy_type_convert(pyexp)
    if typeof(pyexp) in [Sym, PyObject]
        cname = pyexp.__class__.__name__
        if cname == "TensMul"
            return convert(TensMul,pyexp)
        elseif cname == "TensAdd"
            return convert(TensAdd,pyexp)
        elseif cname == "Tensor"
            return convert(IndexedTensor,pyexp)
        elseif cname == "TensorSymmetry"
            return convert(TensorSymmetry,pyexp)
        elseif cname == "Zero"
            return 0
        else
            return pyexp
        end
    else
        return pyexp
    end
end

include("tensor.jl")
include("indices.jl")
include("derivatives.jl")

end

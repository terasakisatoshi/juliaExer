abstract type Employee end

mutable struct Developer <: Employee
    name::String
    iq
    favorite_lang::String
end

mutable struct Manager
    name::String
    iq
    department::String
end

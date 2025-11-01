# DayZ Syntax Reference

Based on Context7 research from `/hawktass/dayz-syntax` (26,486 code snippets)

## Key Differences from My Initial Implementation

### 1. Map Declaration
**Incorrect (what I wrote initially):**
```cpp
map<string, string> m_registeredMethods;
```

**Correct DayZ Syntax:**
```cpp
ref map<string, string> m_registeredMethods;
```

Maps must use `ref` keyword to properly allocate memory. This is crucial for garbage collection in the Enforce Script system.

### 2. Array Access Methods
**Incorrect:**
```cpp
m_registeredMethods[methodName] = description;
m_registeredMethods.Contains(methodName);
```

**Correct DayZ Syntax:**
```cpp
m_registeredMethods.Insert(methodName, description);
m_registeredMethods.Contains(methodName);
m_registeredMethods.Get(methodName);
m_registeredMethods.Remove(methodName);
```

DayZ uses explicit methods for map operations, not bracket notation for insertion.

### 3. Array Type Casting
**Incorrect:**
```cpp
array<string> GetRegisteredMethods()
```

**Correct Pattern (from Context7):**
```cpp
array<string> GetRegisteredMethods()
{
    array<string> methods = new array<string>();
    if (m_registeredMethods)
    {
        for (int i = 0; i < m_registeredMethods.Count(); i++)
        {
            string key = m_registeredMethods.GetKey(i);
            methods.Insert(key);
        }
    }
    return methods;
}
```

Use `.GetKey(i)` and `.GetElement(i)` to iterate maps, not bracket access.

### 4. Singleton Pattern
**Correct Implementation (DayZ style):**
```cpp
class RpcEventListener
{
    private static ref RpcEventListener m_instance;
    
    static RpcEventListener GetInstance()
    {
        if (!m_instance)
        {
            m_instance = new RpcEventListener();
        }
        return m_instance;
    }
};
```

Static singletons require `ref` keyword and proper null checking with `!`.

### 5. Constructor/Destructor Syntax
**Correct DayZ Style:**
```cpp
void ClassName()          // Constructor
{
    // Initialization
}

void ~ClassName()         // Destructor
{
    // Cleanup
}
```

### 6. Array Methods

| Operation | Correct DayZ Syntax |
|-----------|-------------------|
| Create | `array<T> arr = new array<T>()` |
| Insert | `arr.Insert(value)` |
| Count | `arr.Count()` |
| Get element | `arr.Get(index)` |
| Find | `arr.Find(value)` |
| Remove | `arr.Remove(index)` |
| Clear | `arr.Clear()` |

### 7. Map Methods

| Operation | Correct DayZ Syntax |
|-----------|-------------------|
| Create | `map<K, V> m = new map<K, V>()` |
| Insert | `m.Insert(key, value)` |
| Contains | `m.Contains(key)` |
| Get | `m.Get(key)` |
| Remove | `m.Remove(key)` |
| Count | `m.Count()` |
| GetKey(i) | `m.GetKey(i)` (iterate by index) |
| GetElement(i) | `m.GetElement(i)` (iterate by index) |

### 8. Null Checking
**Correct DayZ Pattern:**
```cpp
if (!m_instance)
{
    m_instance = new ClassName();
}

if (m_map && m_map.Contains(key))
{
    // Safe to access
}
```

Always use `!` for null checks, and compound checks with `&&`.

## Data Types

### Basic Types
- `int` - Integer
- `float` - Float
- `string` - String (immutable)
- `bool` - Boolean
- `vector` - 3D vector

### Template Types
- `array<T>` - Dynamic array
- `map<K, V>` - Associative map/dictionary
- `ref T` - Reference type (for garbage collection)

### Type Arrays
- `TStringArray` - Alias for `array<string>`
- `TIntArray` - Alias for `array<int>`
- `TFloatArray` - Alias for `array<float>`

## Class Structure

```cpp
class ClassName
{
    // Private static
    private static ref Type m_staticMember;
    
    // Private
    private ref Type m_privateMember;
    
    // Protected
    protected ref Type m_protectedMember;
    
    // Constructor
    void ClassName()
    {
        // Initialization
    }
    
    // Destructor
    void ~ClassName()
    {
        // Cleanup
    }
    
    // Static methods
    static Type StaticMethod()
    {
    }
    
    // Instance methods
    void Method()
    {
    }
    
    Type GetValue()
    {
        return m_member;
    }
};
```

## Source
DayZ Syntax Reference pulled from Context7 library `/hawktass/dayz-syntax` containing 26,486 code snippets of real DayZ scripting examples.

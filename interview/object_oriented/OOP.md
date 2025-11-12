# 面向对象编程(OOP)

Object-Oriented Programming



基本概念
---

​	在基础概念中，面向对象的三大特征是**封装、继承，多态**。

​	但理解面向对象编程，对于设计和编写高质量的Java代码也至关重要。**面向对象编程是一种编程范式，它将现实世界中的概念抽象为程序中的对象，并通过对象之间的交互来解决问题。**

> 这是mybatis源码中简化版的示例以叙述面向对象编程：

```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;

// 定义一个简化的 Mapper 接口
public interface UserMapper {
    /**
     * 根据用户ID查询用户信息
     *
     * @param id 用户ID
     * @return 查询到的用户对象
     */
    User selectUserById(int id);
}

// 定义 User 实体类
public class User {
    private int id;
    private String username;
    private String email;

    // 省略 getter 和 setter 方法
}

// 定义一个简化的 SqlSessionFactory 类
public class SqlSessionFactory {
    /**
     * 打开一个新的 SqlSession 实例
     *
     * @return 新的 SqlSession 实例
     */
    public SqlSession openSession() {
        // 创建并返回一个 SqlSession 实例
        return new SqlSession();
    }
}

// 定义一个简化的 SqlSession 类
public class SqlSession {
    /**
     * 获取 Mapper 接口的代理对象
     *
     * @param type Mapper 接口的类对象
     * @return Mapper 接口的代理对象
     */
    public <T> T getMapper(Class<T> type) {
        // 返回一个代理对象，用于执行 SQL 映射器接口中定义的方法
        return new MapperProxy<>(type);
    }
}

// 定义一个简化的 MapperProxy 类，用于代理 Mapper 接口的方法
public class MapperProxy<T> implements InvocationHandler {
    private final Class<T> mapperInterface;

    public MapperProxy(Class<T> mapperInterface) {
        this.mapperInterface = mapperInterface;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        // 省略了对方法的具体实现，通常会在这里执行 SQL 查询操作
        // 这里仅作示例，直接返回一个 User 对象
        return new User();
    }
}

// 主类
public class Main {
    public static void main(String[] args) {
        // 创建一个 SqlSessionFactory 实例
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactory();

        // 打开一个 SqlSession 实例
        SqlSession sqlSession = sqlSessionFactory.openSession();

        // 获取 UserMapper 接口的代理对象
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);

        // 调用 Mapper 接口的方法查询用户信息
        User user = userMapper.selectUserById(1);

        // 输出用户信息
        System.out.println(user);
    }
}
```





一、封装(Encapsulation)
---

**封装(Encapsulation)**：封装是面向对象编程的核心概念之一，它将数据和方法**打包到一个单元中**，并**限制外部访问这些数据和方法的方式**。这样可以**隐藏对象的内部细节**，仅**通过公共接口与对象进行交互**，提高了代码的**安全性和可维护性**。

当谈及到封装时，通常会创建一个类，并在类中定义数据(字段)和方法。这些数据和方法可以设置为公共、私有或受保护，从而控制外部访问的方式。通过封装，我们可以**隐藏对象的内部实现细节，并仅暴露必要的公共接口**。这有助于**提高代码的安全性和可维护性**。

> 示例代码：

```java
public class Person {
    /**
     * 私有字段，只能在本类中访问
     */
    private String name;
    private int age;

    /**
     * 构造方法，用于初始化对象。
     *
     * @param name 姓名
     * @param age  年龄
     */
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    /**
     * 设置姓名。
     *
     * @param name 姓名
     * @throws IllegalArgumentException 如果姓名为空，则抛出此异常
     */
    public void setName(String name) {
        // 在这里可以添加一些逻辑，比如验证姓名是否合法
        if (name != null && !name.isEmpty()) {
            this.name = name;
        } else {
            throw new IllegalArgumentException("姓名不能为空");
        }
    }

    /**
     * 获取姓名。
     *
     * @return 姓名
     */
    public String getName() {
        return this.name;
    }

    /**
     * 设置年龄。
     *
     * @param age 年龄
     * @throws IllegalArgumentException 如果年龄不在合理范围内，则抛出此异常
     */
    public void setAge(int age) {
        // 在这里可以添加一些逻辑，比如验证年龄是否合法
        if (age >= 0 && age <= 120) {
            this.age = age;
        } else {
            throw new IllegalArgumentException("年龄必须在0到120之间");
        }
    }

    /**
     * 获取年龄。
     *
     * @return 年龄
     */
    public int getAge() {
        return this.age;
    }
}
```

1. 添加了构造方法，用于在创建对象时初始化对象的状态。
2. 在 `setName` 和 `setAge` 方法中添加了输入验证，确保传入的参数是有效的。如果参数无效，则抛出 `IllegalArgumentException` 异常。
3. 在 `setName` 方法中，检查姓名是否为 `null` 或空字符串，并在不合法时抛出异常。
4. 在 `setAge` 方法中，检查年龄是否在合理范围内（0到120岁），并在不合法时抛出异常。

这些改进使得代码更加规范和可靠，提高了代码的安全性和可维护性。











二、继承(Inheritance)
---

继承**允许一个类(子类)继承另一个类(父类)的==非私有==属性和方法**，从而使得代码的**重用性和扩展性**更强。子类的**可以重写父类的方法或者添加新方法和属性**，以满足特定需求。



### 1.内部实现

1. **继承成员的访问权限**：子类继承父类的成员时，可以访问父类中的公共和受保护成员，但不能访问父类中的私有成员。子类也可以通过父类的接口访问父类中的默认（包）访问权限的成员，前提是子类和父类在同一个包中。
2. **方法重写**：子类可以重写父类的方法，以满足特定需求。重写意味着子类提供了与父类具有相同名称和参数的方法，并且具有不同的实现。当子类对象调用被重写的方法时，将执行子类的实现而不是父类的实现。
3. **添加新方法和属性**：子类可以添加新的方法和属性，以扩展其功能。这些新方法和属性只能在子类中访问，除非它们被定义为公共或受保护的。
4. **构造方法的继承**：子类会默认调用父类的无参构造方法，如果父类没有无参构造方法，或者想调用有参构造方法，则需要在子类构造方法的**第一行通过`super()`来显式调用父类的构造方法**。
5. **多级继承**：一个类可以继承另一个类，而后者本身也可以是另一个类的子类。这样的**继承链可以一直延伸下去，形成多级继承**。

> 示例代码

```java
public class Animal {
    protected String name;

    public Animal(String name) {
        this.name = name;
    }

    public void makeSound() {
        System.out.println("动物发出声音");
    }
}

class Dog extends Animal {
    /**
     * 品种
     */
    private String breed;

    public Dog(String name, String breed) {
        //调用父类的构造方法
        super(name);
        this.breed = breed;
    }

    /**
     * 重新父类方法
     */
    @Override
    public void makeSound() {
        System.out.println("汪汪汪~");
    }

    /**
     * 添加新方法
     */
    public void fetch() {
        System.out.println("它在玩捡球游戏");
    }

    public static void main(String[] args) {
        Dog yellowDog = new Dog("旺柴","中华田园犬");
        System.out.println(yellowDog.name + "来了,它是" + yellowDog.breed);
        yellowDog.makeSound();
        yellowDog.fetch();
    }
}
```

在这个示例中，`Dog` 类继承了 `Animal` 类，并添加了一个新的属性 `breed`，以及一个新的方法 `fetch`。`Dog` 类重写了父类 `Animal` 的 `makeSound` 方法。







三、多态(polymorphism)
---

**多态运行不同的对象的对同一消息作出不同的响应**。通过多态，可以编写更通用的代码，提高了代码的**灵活性和可扩展性**。Java中的多态性通常通过继承和接口实现。

谈到多态时，我们通常会利用继承和接口的特征来实现。以下便是一个使用继承的例子：

```java
// 定义一个形状 Shape 类
class Shape {
    public void draw() {
        System.out.println("绘制形状");
    }
}

// 定义一个圆 Circle 类，继承自 Shape 类
class Circle extends Shape {
    @Override
    public void draw() {
        System.out.println("绘制圆形");
    }
}

// 定义一个矩形 Rectangle 类，继承自 Shape 类
class Rectangle extends Shape {
    @Override
    public void draw() {
        System.out.println("绘制矩形");
    }
}

// 主类
public class Main {
    public static void main(String[] args) {
        // 创建一个圆对象
        Shape circle = new Circle();
        // 创建一个矩形对象
        Shape rectangle = new Rectangle();

        // 调用 draw 方法，由于是多态，根据实际对象的类型，会调用对应的 draw 方法
        circle.draw(); // 输出："绘制圆形"
        rectangle.draw(); // 输出："绘制矩形"
    }
}
```

`Shape` 是一个基类，`Circle` 和 `Rectangle` 是其子类。它们都重写了 `draw` 方法。在 `Main` 类中，我们创建了一个 `Shape` 类型的圆对象和矩形对象，但是它们实际上是 `Circle` 类和 `Rectangle` 类的实例。当我们调用 `draw` 方法时，实际上会根据对象的实际类型来调用对应的重写方法，这就是多态的表现。

这种方式使得代码更加通用，我们可以**在不改变方法调用的前提下，轻松地替换对象的具体类型**。









四、抽象(Abstraction)和消息传递(Message Passing)
---

面向对象的三大特征就是封装、继承，多态。但从更加宽泛的角度而言，对**抽象(Abstraction)**和**消息传递(Message Passing)**的理解也同样很重要!

1. **抽象(Abstraction)**：抽象是面向对象编程的重要概念之一，它是**隐藏对象的复杂性的过程**，使得**用户只需要关注对象的关键特征而忽略其实现细节**。在面向对象编程中，**抽象通过类和接口来实现**。**类定义了对象的属性和方法，而接口定义了对象的行为规范**，通过这些抽象概念，程序员可以更加**专注于问题的本质**而不是实现细节。
2. **消息传递(Message Passing)**：消息传递是面向对象编程中实现对象之间通信的基本方式。对象之间通过发送消息来请求执行特定的操作。这些消息可以是方法调用，**对象在接收到消息后执行相应的方法**。**消息传递是实现封装性和多态性的基础**，通过**隐藏对象的内部细节**，使得对象之间的**通信更加简洁和安全**。
























































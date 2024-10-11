class Demos {
  hlo() {
    throw new Error("Method not implemented.");
  }

  getName = () => 0;

  helo() {
    console.log(this.getName());
    throw new Error("Method not implemented.");
  }

  hello() {
    console.log(this.getName());
    throw new Error("Method not implemented.");
  }
}

const mes = new Demos();
mes.hlo();
mes.helo();
mes.hello();

// version 13

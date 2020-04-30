import Foundation

class VendingMachineProduct {
    var name: String
    var amount: Int
    var price: Double
    var number: Int
    
    init(name: String, amount: Int, price: Double, number: Int) {
        self.name = name
        self.amount = amount
        self.price = price
        self.number = number
    }
}

//TODO: Definir os erros
enum VendingMachineErrors: Error {
    case productNotFound
    case produtUnavailable
    case insufficientFunds
    case productStucked
}

extension VendingMachineErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .produtUnavailable:
            return "O produto não está disponível"
        case .productNotFound:
            return "Produto não encontrado"
        case .insufficientFunds:
            return "Não há dinheiro suficiente"
        case .productStucked:
            return "O produto ficou preso"
        }
    }
}

class VendingMachine {
    private var estoque: [VendingMachineProduct]
    private var money: Double
    
    init(products: [VendingMachineProduct]) {
        self.estoque = products
        self.money = 0
    }
    
    func getProduct(with number: Int, with money: Double) throws {
        //TODO: receber o dinheiro e salvar em uma variável
        self.money += money
        
        //TODO: achar o produto que o cliente quer
        var produtoOptional = estoque.first { (produto) -> Bool in
            return produto.number ==  number
        }
        
        guard let produto = produtoOptional else { throw VendingMachineErrors.productNotFound }
        
        //TODO: ver se ainda tem esse produto
        guard produto.amount > 0 else { throw VendingMachineErrors.produtUnavailable }
        
        //TODO: ver se o dinheiro é o suficiente pro produto
        guard produto.price <= self.money else { throw VendingMachineErrors.insufficientFunds }
        
        
        //TODO: entregar o produto
        //10% das vezes vai jogar um erro ao inves de te retornar o produto (ele ficou preso da maquina)
        self.money -= produto.price
        produto.amount -= 1 //tirando 1 do estoque
        
        if Int.random(in: 0...100) < 10 { throw VendingMachineErrors.productStucked}
    }
    
    func getTroco() -> Double {
        //TODO: devolver o dinheiro que não foi gasto
        defer {
            self.money = 0
        }
        return self.money
        //ele vai retornar o money e depois vai zerar
    }
    
    func showProducts() {
        for i in estoque {
            print("Produto: \(i.name) ; Número: \(i.number)")
        }
    }
}

let vendingMachine = VendingMachine( products: [
    VendingMachineProduct(name: "Batata", amount: 4, price: 3.00, number: 1),
    VendingMachineProduct(name: "Água", amount: 10, price: 4.00, number: 2),
    VendingMachineProduct(name: "Crregador de iPhone", amount: 3, price: 50.00, number: 3),
    VendingMachineProduct(name: "Unicórnio de pelúcia", amount: 6, price: 10.00, number: 4),
    VendingMachineProduct(name: "Trator", amount: 1, price: 200.00, number: 5)
])

vendingMachine.showProducts()

do {
    try vendingMachine.getProduct(with: 1 , with: 20.00)
    try vendingMachine.getProduct(with: 4, with: 20.00)
    try vendingMachine.getProduct(with: 2, with: 10.00)
} catch VendingMachineErrors.productStucked {
    print("Pedimos desculpas, mas houve um problema, seu produto ficou preso")
} catch {
    print(error.localizedDescription)
}

import Foundation

struct OurToDoData {
    let tripTitle: String
    let tripDeadline: String
    let tripStartDate: String
    let tripEndDate: String
    let percentage: Int
    let friends: [Friend]
    let ourToDo: [OurToDo]
    
    init(tripTitle: String, tripDeadline: String, tripStartDate: String, tripEndDate: String, percentage: Int, friends: [Friend], ourToDo: [OurToDo]) {
        self.tripTitle = tripTitle
        self.tripDeadline = tripDeadline
        self.tripStartDate = tripStartDate
        self.tripEndDate = tripEndDate
        self.percentage = percentage
        self.friends = friends
        self.ourToDo = ourToDo
    }
    
    static var ourToDoData: OurToDoData =
        .init(
            tripTitle: "지민이랑 스페인",
            tripDeadline: "여행일까지 16일 남았어요!",
            tripStartDate: "12월 16일",
            tripEndDate: "12월 25일",
            percentage: 49,
            friends: Friend.friendData,
            ourToDo: OurToDo.ourToDo
        )
}

struct Friend {
    let profileImg: String
    let name: String
    
    init(profileImg: String, name: String) {
        self.profileImg = profileImg
        self.name = name
    }
    
    static var friendData: [Friend] = [
        .init(profileImg: "larva", name: "지민"),
        .init(profileImg: "larva", name: "영서"),
        .init(profileImg: "larva", name: "아린"),
        .init(profileImg: "larva", name: "현진"),
        .init(profileImg: "larva", name: "성준"),
        .init(profileImg: "larva", name: "희슬")
    ]
}

struct OurToDo {
    let todoTitle: String
    let manager: [String]
    let deadline: String
    let isComplete: Bool
    
    init(todoTitle: String, manager: [String], deadline: String, isComplete: Bool) {
        self.todoTitle = todoTitle
        self.manager = manager
        self.deadline = deadline
        self.isComplete = isComplete
    }
    
    static var ourToDo: [OurToDo] = 
    [
        .init(todoTitle: "지민", manager: ["지민"], deadline: "2023.09.23", isComplete: false),
        .init (todoTitle: "아린 현진 완", manager: ["아린", "현진"], deadline: "2023.09.21", isComplete: true),
        .init(todoTitle: "성준 희슬 영서", manager: ["성준", "희슬", "영서"], deadline: "2023.09.18", isComplete: false),
        .init(todoTitle: "성준", manager: ["성준"], deadline: "2023.09.29", isComplete: false),
        .init(todoTitle: "희슬 영서", manager: ["희슬", "영서"], deadline: "2023.09.23", isComplete: false),
        .init(todoTitle: "지민 희슬 영서 완", manager: ["지민", "희슬", "영서"], deadline: "2023.09.23", isComplete: true),
        .init(todoTitle: "지민 완", manager: ["지민"], deadline: "2023.09.23", isComplete: true),
        .init(todoTitle: "영서", manager: ["영서"], deadline: "2023.09.25", isComplete: false),
        .init(todoTitle: "성준 희슬 영서", manager: ["성준", "희슬", "영서"], deadline: "2023.09.21", isComplete: false),
        .init(todoTitle: "성준 희슬 영서 완", manager: ["성준", "희슬", "영서"], deadline: "2023.09.18", isComplete: true),
        .init(todoTitle: "지민", manager: ["지민"], deadline: "2023.09.23", isComplete: false),
        .init (todoTitle: "아린 현진 완", manager: ["아린", "현진"], deadline: "2023.09.21", isComplete: true),
        .init(todoTitle: "성준 희슬 영서", manager: ["성준", "희슬", "영서"], deadline: "2023.09.18", isComplete: false),
        .init(todoTitle: "성준", manager: ["성준"], deadline: "2023.09.29", isComplete: false),
        .init(todoTitle: "희슬 영서", manager: ["희슬", "영서"], deadline: "2023.09.23", isComplete: false),
        .init(todoTitle: "지민 희슬 영서 완", manager: ["지민", "희슬", "영서"], deadline: "2023.09.23", isComplete: true),
        .init(todoTitle: "지민 완", manager: ["지민"], deadline: "2023.09.23", isComplete: true),
        .init(todoTitle: "영서", manager: ["영서"], deadline: "2023.09.25", isComplete: false),
        .init(todoTitle: "성준 희슬 영서", manager: ["성준", "희슬", "영서"], deadline: "2023.09.21", isComplete: false),
        .init(todoTitle: "성준 희슬 영서 완", manager: ["성준", "희슬", "영서"], deadline: "2023.09.18", isComplete: true)
    ]
}


//
//  SearchListView.swift
//  BookBillionaireUser
//
//  Created by 홍승표 on 4/11/24.
//

import SwiftUI
import BookBillionaireCore

struct BookSearchListView: View {
    @Binding var searchBook: String
    @Binding var filteredBooks: [Book]
    let users: [User] = []
    @EnvironmentObject var bookService: BookService
    @EnvironmentObject var userService: UserService
    @StateObject private var searchService = SearchService()
        var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("검색된 책 목록")
                    .font(.title3)
                    .foregroundStyle(.accent)
                Spacer()
            }
            
            if searchService.filteredBooks.isEmpty {
                Text("검색한 결과가 없습니다")
                
            } else {
                LazyVStack(alignment: .leading, spacing: 10) {
                    ForEach(searchService.filteredBooks) { book in
                        NavigationLink {
                            BookDetailView(book: book, user: userService.loadUserByID(book.ownerID))
                        } label: {
                            BookListRowView(book: book)
                        }
                        
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
    }
    
}

#Preview {
    BookSearchListView(searchBook: .constant("원도"), filteredBooks: .constant([Book(owenerID: "", title: "", contents: "", authors: [""], rentalState: .rentalAvailable)]))
}


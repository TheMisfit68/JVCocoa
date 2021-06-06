//
//  JVTerminalCommand.swift
//  
//
//  Created by Jan Verrept on 04/06/2021.
//

import Foundation

public class TerminalCommand{
	
	let task = Process()
	let pipe = Pipe()

	public init(_ command:String){
		
		task.launchPath = "/bin/zsh"
		task.arguments = ["-c", command]
		task.waitUntilExit()

		task.standardOutput = pipe
		task.standardError = pipe

	}
	
	public func execute()-> String{
		
		task.launch()

		let data = pipe.fileHandleForReading.readDataToEndOfFile()
		let output = String(data: data, encoding: .utf8)!
		
		return output
	}
	
}


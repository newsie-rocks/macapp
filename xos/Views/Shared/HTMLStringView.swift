//
//  HtmlStringView.swift
//  xos
//
//  Created by nick on 01/08/2023.
//

import SwiftUI
import WebKit

#if os(iOS)
public typealias ViewRepresentable = UIViewRepresentable
#elseif os(macOS)
public typealias ViewRepresentable = NSViewRepresentable
#endif

struct HTMLStringView: ViewRepresentable {
    let htmlContent: String

    init(_ htmlContent: String) {
        self.htmlContent = htmlContent.appending(
            """
            <style>
                body {
                    font-family: -apple-system, "Helvetica Neue", "Lucida Grande";
                    font-size: 2.5rem;
                    line-height: 1.5em;
                    text-align: justify;
                }

                img {
                    max-width: 100%;
                }
            </style>
            """
        )
    }

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func makeNSView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

struct HTMLStringView_Previews: PreviewProvider {
    // swiftlint:disable line_length
    static var htmlContent = """
     \n
     <img src=\"https://spectrum.ieee.org/media-library/an-collage-including-a-bearded-bald-smiling-man-with-glasses-and-a-bipedal-white-robot.jpg?id=34671434&width=1245&height=700&coordinates=0%2C0%2C0%2C247\"
        width = "100%"
    />
     <br/><br/>
     <p><strong>When <a href=\"https://en.wikipedia.org/wiki/Marc_Raibert\" rel=\"noopener noreferrer\" target=\"_blank\">Marc Raibert</a> founded</strong> <a href=\"https://www.bostondynamics.com/\" rel=\"noopener noreferrer\" target=\"_blank\">Boston Dynamics</a> in 1992, he wasn’t even sure it was going to be a robotics company—he thought it might become a <a href=\"https://spectrum.ieee.org/marc-raibert-boston-dynamics-instutute\" target=\"_self\">modeling and simulation company</a> instead. Now, of course, Boston Dynamics is the authority in legged robots, with its <a href=\"https://robotsguide.com/robots/atlas2016\" rel=\"noopener noreferrer\" target=\"_blank\">Atlas biped</a> and <a href=\"https://robotsguide.com/robots/spot\" rel=\"noopener noreferrer\" target=\"_blank\">Spot quadruped</a>. But as the company focuses more on <a href=\"https://spectrum.ieee.org/boston-dynamics-spot-robot-dog-now-available\" target=\"_self\">commercializing its technology</a>, Raibert has become more interested in pursuing the long-term vision of what robotics can be.</p>
     <p>To that end, Raibert founded the <a href=\"https://theaiinstitute.com/\" rel=\"noopener noreferrer\" target=\"_blank\">Boston Dynamics AI Institute</a> in August of 2022. Funded by <a href=\"https://www.hyundaiusa.com/us/en\" rel=\"noopener noreferrer\" target=\"_blank\">Hyundai</a> (the company also <a href=\"https://spectrum.ieee.org/hyundai-buys-boston-dynamics\" target=\"_self\">acquired Boston Dynamics</a> in 2020), the Institute’s first few projects will focus on making robots useful outside the lab by teaching them to better understand the world around them.</p>
     <h3>Marc Raibert </h3>
     <br/>
     <p>Raibert was a professor at Carnegie Mellon and MIT before founding Boston Dynamics in 1992. He now leads the Boston Dynamics AI Institute.</p>
     <p>At the 2023 IEEE <a href=\"https://www.icra2023.org/\" rel=\"noopener noreferrer\" target=\"_blank\">International Conference on Robotics at Automation</a> (ICRA) in London this past May, Raibert gave a keynote talk that discussed some of his specific goals, with an emphasis on developing practical, helpful capabilities in robots. For example, Raibert hopes to teach robots to watch humans perform tasks, understand what they’re seeing, and then do it themselves—or know when they don’t understand something, and how to ask questions to fill in those gaps. Another of Raibert’s goals is to teach robots to inspect equipment to figure out whether something is working—and if it’s not, to determine what’s wrong with it and make repairs. Raibert showed concept art at ICRA that included robots working in domestic environments such as kitchens, living rooms, and laundry rooms as well as industrial settings. “I look forward to having some demos of something like this happening at ICRA 2028 or 2029,” Raibert quipped. </p>
     <p>Following his keynote, <em>IEEE Spectrum</em> spoke with Raibert, and he answered five questions about where he wants robotics to go next.</p>
     <p><strong>At the Institute, you’re starting to share your vision for the future of robotics more than you did at Boston Dynamics. Why is that?</strong></p>
     <p><strong>Marc Raibert:</strong> At Boston Dynamics, I don’t think we talked about the vision. We just did the next thing, saw how it went, and then decided what to do after that. I was taught that when you wrote a paper or gave a presentation, you showed what you had accomplished. All that really mattered was the data in your paper. You could talk about what you want to do, but people talk about all kinds of things that way—the future is so cheap, and so variable. That’s not the same as showing what you <em>did</em>. And I took pride in showing what we actually did at Boston Dynamics.</p>
     <p>But if you’re going to make the Bell Labs of robotics, and you’re trying to do it quickly from scratch, you have to paint the vision. So I’m starting to be a little more comfortable with doing that. Not to mention that at this point, we don’t have any actual results to show.</p>
     <p class=\"shortcode-media shortcode-media-rebelmouse-image\">\n<img alt=\"A group of images showing a robot observing a human doing a task then performing it on it\'s own.  \" class=\"rm-shortcode\" data-rm-shortcode-id=\"d5f28eb4c511504e745da9dafa95db18\" data-rm-shortcode-name=\"rebelmouse-image\" id=\"7d56a\" loading=\"lazy\" src=\"https://spectrum.ieee.org/media-library/a-group-of-images-showing-a-robot-observing-a-human-doing-a-task-then-performing-it-on-it-s-own.png?id=34671653&width=980\"/>\n<small class=\"image-media media-caption\" placeholder=\"Add Photo Caption...\">Right now, robots must be carefully trained to complete specific tasks. But Marc Raibert wants to give robots the ability to watch a human do a task, understand what\\u2019s happening, and then do the task themselves, whether it\\u2019s in a factory [top left and bottom] or in your home [top right and bottom].</small>\n<small class=\"image-media media-photo-credit\" placeholder=\"Add Photo Credit...\">\n            Boston Dynamics AI Institute\n        </small>\n</p>
     <p><strong>The Institute will be putting a lot of effort into how robots can better manipulate objects. What’s the opportunity there?</strong><br/></p>
     <p><strong>Raibert: </strong>I think that for 50 years, people have been working on manipulation, and it hasn’t progressed enough. I’m not criticizing anybody, but I think that there’s been so much work on path planning, where path planning means how you move through open space. But that’s not where the action is. The action is when you’re in contact with things—we humans basically juggle with our hands when we’re manipulating, and I’ve seen very few things that look like that. It’s going to be hard, but maybe we can make progress on it. One idea is that going from static robot manipulation to dynamic can advance the field the way that going from static to dynamic advanced legged robots.</p>
     <p><strong>How are you going to make your vision happen?</strong></p>
     <p><strong>Raibert:</strong> I don’t know any of the answers for how we’re going to do any of this! That’s the technical fearlessness—or maybe the technical foolishness. My long-term hope for the Institute is that most of the ideas don’t come from me, and that we succeed in hiring the kind of people who can have ideas that lead the field. We’re looking for people who are good at bracketing a problem, doing a quick pass at it (“quick” being maybe a year), seeing what sticks, and then taking another pass at it. And we’ll give them the resources they need to go after problems that way.</p>
     <p class=\"pull-quote\">“If you’re going to make the Bell Labs of robotics, and you’re trying to do it quickly from scratch, you have to paint the vision.”</p>
     <p><strong>Are you concerned about how the public perception of robots, and especially of robots you have developed, is <a href=\"https://www.wired.com/story/nypd-spot-boston-dynamics-robot-dog/\" rel=\"noopener noreferrer\" target=\"_blank\">sometimes negative</a>?</strong></p>
     <p><strong>Raibert:</strong> The media can be over the top with stories about the fear of robots. I think that by and large, people really love robots. Or at least, a lot of people <em>could</em> love them, even though sometimes they’re afraid of them. But I think people just have to get to know robots, and at some point I’d like to open up an outreach center where people could interact with our robots in positive ways. We are actively working on that.</p>
     <p><strong>What do you find so interesting about <a href=\"https://spectrum.ieee.org/how-boston-dynamics-taught-its-robots-to-dance\" target=\"_self\">dancing robots</a>?</strong></p>
     <p><strong>Raibert:</strong> I think there are a lot of opportunities for emotional expression by robots, and there’s a lot to be done that hasn’t been done. Right now, it’s labor-intensive to create these performances, and the robots are not perceiving anything. They’re just playing back the behaviors that we program. They should be <em>listening</em> to the music. They should be seeing who they’re dancing with, and coordinating with them. And I have to say, every time I think about that, I wonder if I’m getting soft because robots don’t <em>have</em> to be emotional, either on the giving side or on the receiving side. But somehow, it’s captivating.</p>
     <p>Marc Raibert was a professor at Carnegie Mellon and MIT before founding Boston Dynamics in 1992. He now leads the Boston Dynamics AI Institute.</p>
     <p><em>This article appears in the August 2023 print issue as “5 Questions <span style=\"background-color: initial;\">for </span>Marc Raibert.”</em></p>
    """
    // swiftlint:enable line_length

    static var previews: some View {
        HTMLStringView(htmlContent)
    }
}

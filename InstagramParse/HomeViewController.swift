//
//  HomeViewController.swift
//  InstagramParse
//
//  Created by Clark Kent on 3/6/16.
//  Copyright © 2016 Antonio Singh. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class HomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onLogout(sender: AnyObject) {
        
        PFUser.logOut()
        
        print("User is now logged out")
    }
    var instaPosts: [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getPosts()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if posts != nil {
                self.instaPosts = posts
                MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                self.tableView.reloadData()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            } else {
                print(error?.localizedDescription)
            }
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        let tempImageView = UIImageView(image: UIImage(named: "canada"))
        tempImageView.frame = self.tableView.frame
        self.tableView.backgroundView = tempImageView;
        
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPosts()
    {
        let query = PFQuery(className: "UserMedia")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock { (results: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                //print(self.instaPosts)
                self.instaPosts = results
                self.tableView.reloadData()
                
            } else {
                print(error)
            }
        }
        
    }
    
    func loadList(notification: NSNotification){
        self.getPosts()
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if instaPosts != nil {
            return instaPosts!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as! PhotoCell
        
        cell.Photos = instaPosts[indexPath.row]
        
        return cell
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        query.findObjectsInBackgroundWithBlock { (posts: [PFObject]?, error: NSError?) -> Void in
            if posts != nil {
                self.instaPosts = posts
                self.tableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
        refreshControl.endRefreshing()
    }
    
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



const express=require("express");
const mongoose=require("mongoose");
const app=express();
const Port=process.env.PORT||2000;
mongoose.connect("mongodb+srv://bloguser:vicky1234@cluster0.7ngse.mongodb.net/blogappdatabase?retryWrites=true&w=majority",
{
    useNewUrlParser:true,
}
);
const connection=mongoose.connection;
connection.once("open",()=>{-
    console.log("Connected to mongodb");
});

//middlewares
app.use("/uploads",express.static("uploads"));
app.use(express.json());
const userRoute=require('./routes/user.js');
app.use("/user",userRoute);
const profileRoute=require('./routes/profile.js');
app.use("/profile",profileRoute);
const blogRoute=require('./routes/blogpost.js');
app.use("/blogpost",blogRoute);

app.route("/").get((req,res)=>{res.json("api02")});
app.listen(Port,"0.0.0.0",()=>console.log(`Port  ${Port}`)); 
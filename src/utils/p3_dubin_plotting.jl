#################################
### Plotting helper functions ###
#################################

PyPlot.svg(true)

function set_fonts()::Nothing
    # Set the figure fonts.
    fig_small_sz = 12
    fig_med_sz = 15
    fig_big_sz = 17
    plt.rc("text", usetex=true)
    plt.rc("font", size=fig_small_sz, family="serif")
    plt.rc("axes", titlesize=fig_small_sz)
    plt.rc("axes", labelsize=fig_med_sz)
    plt.rc("xtick", labelsize=fig_small_sz)
    plt.rc("ytick", labelsize=fig_small_sz)
    plt.rc("legend", fontsize=fig_small_sz)
    plt.rc("figure", titlesize=fig_big_sz)
    plt.rc("figure", dpi=300) 
    return nothing
end
;

set_fonts()
set_fonts()

#######################
### Trajectory plot ###
#######################

function plot_trajectory() 

    ctres, overlap = 1000, 3
    N = size(sol.xd, 2)
    xct = hcat([sample(sol.xc, t) for t in LinRange(0, 1, ctres)]...)
    vct = vcat([sample(sol.uc, t)[1] for t in LinRange(0, 1, ctres)]...)
    cmap = generate_colormap("inferno"; minval=minimum(vct), maxval=maximum(vct))

    # plot_options = Dict("xtick.labelsize"=>9,
    #                     "ytick.labelsize"=>9,
    #                     "axes.labelsize"=>11)
    # fig = create_figure((4, 4); options = plot_options)

    fig = plt.figure(figsize=(4,4), dpi=300)
    plt.clf()

    ax = setup_axis!(111, xlabel="\$x\$ [m]", ylabel="\$y\$ [m]",
                     axis="equal", cbar=cmap, clabel="Speed, \$v\$ [m/s]",
                     cbar_aspect=40)

    ax.set_xlim(-1.0, 1.0)
    ax.set_ylim(-0.5, 2.5)

    ax.plot(sol.xd[1, :], sol.xd[2, :],
            linestyle="none", marker="o", markerfacecolor=DarkBlue,
            markeredgecolor="white", markeredgewidth=0.2, markersize=3,
            zorder=20)
    line_segs = Vector{Matrix}(undef, 0)
    line_clrs = Vector{NTuple{4, Real}}(undef, 0)
    for k=1:ctres-overlap
        push!(line_segs, xct[1:2, k:k+overlap]')
        push!(line_clrs, cmap.to_rgba(vct[k]))
    end
    trajectory = PyPlot.matplotlib.collections.LineCollection(
        line_segs, zorder=10, colors = line_clrs, linewidths=3,
        capstyle="round")
    ax.add_collection(trajectory)
    Rect = PyPlot.matplotlib.patches.Rectangle
    car_length = 0.2
    for k=1:N
        local xl, xw = [1;1;-1;-1;1]*car_length/2, [1;-1;-1;1;1]*car_width/2
        local yl, yw = [1;1;-1;-1;1]*car_length/2, [-1;1;1;-1;-1]*car_width/2
        local ang = sol.xd[3,k]
        local xc = sol.xd[1,k].+xl.*sin(ang).+xw.*cos(ang)
        local yc = sol.xd[2,k].+yl.*cos(ang).+yw.*sin(ang)
        ax.fill(xc, yc,
                linewidth=1,
                edgecolor=DarkBlue,
                facecolor=rgb2pyplot(parse(RGB, Red), a=0.5),
                zorder=6)
    end
    ang = LinRange(0, 2*pi, 100)
    obs = ([cos.(ang)'; sin.(ang)']*r_0).+c_0
    ax.fill(obs[1, :], obs[2, :],
            linewidth=1,
            edgecolor=Blue,
            facecolor=rgb2pyplot(parse(RGB, Green), a=0.5),
            zorder=5)

    # plt.autoscale()
    # fig.savefig("media/p3_ptr_traj_forward.png", bbox_inches="tight")
    # fig.savefig("media/p3_scvx_traj_forward.png", bbox_inches="tight")
    # fig.savefig("media/p3_ptr_traj_reverse.png", bbox_inches="tight")
    # fig.savefig("media/p3_scvx_traj_reverse.png", bbox_inches="tight")

    # plt.show()
    ;
    
end